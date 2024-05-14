foreach ($localuser in Get-LocalUser)
    {
        if (($localuser.Enabled -eq $false))
        {
        get-localuser -Name $localuser.name | Enable-LocalUser
        set-LocalUser -Name $localuser.name -Password (ConvertTo-SecureString -AsPlainText "1234" -Force) -AccountExpires (get-date).AddDays(30)
        }
    
    }
