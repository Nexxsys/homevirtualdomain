param( [Parameter(Mandatory=$true)] $JSONFile)

function CreateADGroup(){
    param (
        [Parameter(Mandatory=$true)]
        $groupObject
    )
    $name = $groupObject.name
    New-ADGroup -name $name -GroupScope Global
}
function CreateADUser(){
    param( [Parameter(Mandatory=$true)] $userObject)

    # Pull out the name and pass word from the JSON object
    $name = $userObject.name
    $firstname, $lastname = $name.Split(" ")
    $password = $userObject.password

    $username = ($firstname[0] + $lastname).ToLower()
    $samAccountName = $username
    $principalname = ($name[0] + $lastname)
    
    # Create the AD User Object
    New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -PassThru | Enable-ADAccount

    # Add the user to is appropriate group
    foreach($group_name in $userObject.groups){
        
        try{
            Get-ADGroup -Identity "$group_name"
            Add-ADGroupMember -Identity $group -Members $username
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{
            Write-Warning "AD Computer Object Not Found"
        }
    }
}

function WeakenPasswordPolicy(){
    secedit /export /cfg c:\Windows\Tasks\secpol.cfg
    (Get-Content C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\Windows\Tasks\secpol.cfg
    secedit /configure /db c:\windows\security\local.sdb /cfg c:\Windows\Tasks\secpol.cfg /areas SECURITYPOLICY
    rm -force c:\Windows\Tasks\secpol.cfg -confirm:$false
    Set-ADDefaultDomainPasswordPolicy -Identity "XYZ.com" -MinPasswordLength 4
}

WeakenPasswordPolicy

$json = (Get-Content $JSONFile | ConvertFrom-JSON)

$Global:Domain = $json.domain
foreach($group in $json.groups){
    CreateADGroup $group
}
foreach($user in $json.users){
    CreateADUser $user
}