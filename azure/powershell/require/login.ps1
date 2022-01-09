function Login()
{
    $context = Get-AzContext;
    $credentials = Get-AcgCredentials;

    if (!$context)
    {
        Login-AzAccount -Credential $credentials | Out-Null
    }
    else
    {
        $AccessToken = Get-AzAccessToken -ErrorAction SilentlyContinue
        if ($null -eq $AccessToken -or $credentials.username -ne  $AccessToken.UserId)
        {
            Login-AzAccount -Credential $credentials | Out-Null
        }
    }
}


function Get-AcgCredentials()
{
    $filePath = Join-Path -Path  $PSScriptRoot -ChildPath .. -Resolve
    $file = Get-ChildItem -Path $filePath -Filter .env

    if ($file)
    {
        $lines = Get-Content $file;
        if ($lines)
        {
            foreach ($line in $lines)
            {
                switch -Wildcard ($line)
                {
                    "Username*"
                    {
                        $username = $line.replace("Username: ", $null)
                    }
                    "Password*"
                    {
                        $password = $line.replace("Password: ", $null)
                    }
                }
            }
        }
        else
        {
            $fileContent = New-AcgCredentials
            Set-Content "$( $filePath )\.env" $fileContent
        }
    }
    else
    {
        New-Item "$( $filePath )\.env" | Out-Null
        $fileContent = New-AcgCredentials
        Set-Content "$( $filePath )\.env" $fileContent
        $file = Get-ChildItem -Path $filePath -Filter .env
        $lines = Get-Content $file;

        foreach ($line in $lines)
        {
            switch -Wildcard ($line)
            {
                "Username*"
                {
                    $username = $line.replace("Username: ", $null)
                }
                "Password*"
                {
                    $password = $line.replace("Password: ", $null)
                }
            }
        }
    }

    if ($null -ne $username -and $null -ne $password)
    {
        $SecurePassword = ConvertTo-SecureString “$password” -AsPlainText -Force
        $credentials = New-Object System.Management.Automation.PSCredential($username, $SecurePassword)
        return $credentials
    }
    else
    {
        Write-Error "No Credentials found!"
    }

}

function New-AcgCredentials()
{
    $username = Read-Host -Prompt "Username";
    $password = Read-Host -Prompt "Password" -AsSecureString;
    $credentials = (New-Object PSCredential $username, $password).GetNetworkCredential()
    $fileContent = @"
Username: $( $credentials.username )
Password: $( $credentials.password )
"@
    return $fileContent
}

Login