cls

# ouvrir la boite de dialogue pour recuperer le fichier csv

[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
 
# Creer la boite de dialogue 

$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = "C:\"
$dialog.Filter = "CSV (*.csv)| *.csv" 
$dialog.ShowDialog() | Out-Null
 
# recuperer le chemin du fichier 

$CSVFichier = $dialog.FileName

# Importer le fichier dans une variable 

$CSV = Import-Csv -LiteralPath "$CSVFichier"

$rep = 'o'


while ($rep -like 'o')
    { 

      
        [int]$choix = Read-Host "`n`1 : Rechercher une Personne `n`2 : Supprimer une Personne `n` `n`Votre choix "
        cls  
        

        if ($choix -eq '1')
            {
                write-host "" 
                Write-host "################  RECHERCHE  ################ "
                write-host ""
                $nom = Read-Host "Donnez le nom "
                $pre = Read-Host "Donnez le prenom "
                $val1 = 'faux'
                cls
                foreach($user in $CSV) 
                    {  
                        if (($nom -like $($user.FirstName)) -and ($pre -like $($user.LastName)))
                            {
                                write-host ""
                                Write-Host "Nom : $($user.FirstName) `n`Prenom : $($user.LastName) `n`Telephone : $($user.MobilePhone)" `n
                                $val1 = 'vrai'
                                break
                            }
                    }
                if ($val1 -notlike 'vrai')
                    {
                        write-host ""
                        write-host "la personne n existe pas"
                        write-host ""
                    }
            }

        if ($choix -eq '2')
            { 
                $sour = Get-Content $CSVFichier
                $dest = "C:\NewAnnuaire.txt"
                $Val2 = "faux"
                $Val3 = "faux"
                write-host ""
                Write-host "###################  SUPRESSION  ################### "
                write-host ""
                $nom = Read-Host "Donnez le nom "
                $prenom = Read-Host "Donnez le prenom "
                
                foreach($user in $CSV)
                    { 
                        if ($nom -eq "$($user.FirstName)" -and $prenom -eq $($user.LastName))
                            {
                                $Val3 = 'vrai' 
                            }
                    }
                if ($Val3 -eq "faux")
                       {
                            write-host ""
                            write-host "La personne ne peut pas etre supprimee car elle n existe pas !!!"
                       }

                elseif(!(Test-Path $dest))
                   {
                        foreach($line in $sour) 
                                {
                                    if (!($line.Contains($nom)))
                                        {
                                            if (!($line.Contains($prenom)))
                                                {
                                                    add-content $dest $line -Force
                                                }
                                        }
                                }
                        write-host ""
                        write-host "Suppression reussi"
                  }
                  
                else 
                    {
                        write-host ""
                        Write-Host "suppression annulee, le fichier de destionation existe deja!!"
                    }
            }
      

      write-host ""
      $rep = read-Host "Voulez vous refaire un choix ? o`/n "
      
      cls

      
    
    }
