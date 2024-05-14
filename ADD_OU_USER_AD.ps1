while ($rep -like 'o')
    { 
        [int]$choix = Read-Host "`n`1 : Ajoute des UO `n`2 : Ajouter des Utilisateurs `n` `n`Votre choix "
        cls  

        if ($choix -eq '1')
            {
                write-host "" 
                Write-host "################  AJOUT DES UNITES ORG  ################ "
                write-host ""
                [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
 
                $dialog = New-Object System.Windows.Forms.OpenFileDialog
                $dialog.InitialDirectory = "C:\"
                $dialog.Filter = "CSV (*.csv)| *.csv" 
                $dialog.ShowDialog() | Out-Null

                $CSVFichier = $dialog.FileName

                $CSV = Import-Csv -LiteralPath "$CSVFichier" -Delimiter ";"

                foreach ($OU in $CSV)
                {
                        New-ADOrganizationalUnit -Name $OU.nom_uo -Path $OU.domaine
                        Write-Host "Creation de l'OU : " $OU.nom_uo
                } 
                   
                
            }
         if ($choix -eq '2')
            {
                write-host "" 
                Write-host "################  AJOUT  ################ "
                write-host ""
                [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
 
                $dialog = New-Object System.Windows.Forms.OpenFileDialog
                $dialog.InitialDirectory = "C:\"
                $dialog.Filter = "CSV (*.csv)| *.csv" 
                $dialog.ShowDialog() | Out-Null

                $CSVFichier = $dialog.FileName

                $CSV = Import-Csv -LiteralPath "$CSVFichier" -Delimiter ";"

                Foreach($Usager in $CSV)
                    {

                        $UsagerPrenom = $Usager.prenom
                        $UsagerNom = $Usager.nom
                        $UsagerLogin = ($UsagerPrenom).Substring(0,1) + "." + $UsagerNom
                        $UsagerNC = $Usager.nom_complet
                        $UsagerMail = $Usager.email
                        $UsagerOU = "OU=" + $Usager.nom_uo + "," + $Usager.domaine
                        $UsagerMDP = "Groupe460"

                        # Vérifier la présence de l'utilisateur dans l'AD
                        if (Get-ADUser -Filter {SamAccountName -eq $UsagerLogin})
                            {
                                Write-Warning "L'identifiant $UsagerLogin existe déjà dans l'AD"
                            }
                        else
                            {
                                New-ADUser -Name "$UsagerNom $UsagerPrenom" `
                                        -DisplayName "$UsagerNC" `
                                        -GivenName $UsagerPrenom `
                                        -Surname $UsagerNom `
                                        -SamAccountName $UsagerLogin `
                                        -UserPrincipalName "$UsagerMail" `
                                        -City $Usager.region `
                                        -State $Usager.county `
                                        -PostalCode $Usager.postalZip `
                                        -OfficePhone $Usager.phone `
                                        -Department $Usager.departement `
                                        -Description $Usager.ndepartement `
                                        -Path $UsagerOU `
                                        -AccountPassword(ConvertTo-SecureString $UsagerMDP -AsPlainText -Force) `
                                        -ChangePasswordAtLogon $true `
                                        -Enabled $true
 

                                Write-Output "Création de l'utilisateur : $UsagerLogin ($UsagerNom $UsagerPrenom)"
                           }
                    }
            }
    }
            
