param( [Parameter(Mandatory=$true)] $OutputJSONFile)
# Generates a Random list of Group Names, First Namess, Last Names and Passwords
$group_names = [System.Collections.Arraylist](Get-Content "data/group_names.txt")
$first_names = [System.Collections.Arraylist](Get-Content "data/first_names.txt")
$last_names = [System.Collections.Arraylist](Get-Content "data/last_names.txt")
$passwords = [System.Collections.Arraylist](Get-Content "data/passwords.txt")

$groups = @()
$users = @()

$num_groups = 10

for ($i = 0; $i -lt $num_groups; $i++){
    $new_group = (Get-Random -InputObject $group_names)
    # $groups += $new_group
    $groups += @{ "name" = $new_group }
    $group_names.Remove($new_group)
}
# echo $groups

$num_users = 100

for ($i = 0; $i -lt $num_users; $i++){
    $first_name = (Get-Random -InputObject $first_names)
    $last_name = (Get-Random -InputObject $last_names)
    $password = (Get-Random -InputObject $passwords)
    $new_user = @{
        "name" = "$first_name $last_name"
        "password"=$password
        "groups" = @( (Get-Random -InputObject $groups).name )
        }
    # echo $new_user
    $users += $new_user

    $first_names.Remove($first_name)
    $last_names.Remove($last_name)
    $passwords.Remove($password)
}

echo @{
    "domain" = "xyz.com"
    "groups" = $groups
    "users" = $users
} | ConvertTo-Json | Out-File $OutputJSONFile


