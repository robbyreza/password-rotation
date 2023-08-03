# Set the Vault address and authentication token
$vaultAddress = "http://127.0.0.1:8200"
$authToken = "hvs.zsjUDl89iH0FVBU9aO5Yboti"


$json = Invoke-WebRequest -Method GET -Uri 'http://127.0.0.1:8200/v1/sys/policies/password/baseline/generate' -Headers @{ "X-Vault-Token" = $authToken }

$psobj = ConvertFrom-Json $json

Write-Output $psobj.data.password

# Set the password to be stored in the Vault
$password = $psobj.data.password


# Set the request body to include the password as a value
$requestBody = @{
    "username" = "test"
    "value" = $password
}

# Send a POST request to the Vault API to create a new secret
Invoke-WebRequest -Method POST -Uri 'http://127.0.0.1:8200/v1/kv/password' -Body $requestBody -Headers @{ "X-Vault-Token" = $authToken }


$encrypted = ConvertTo-SecureString $password -AsPlainText -Force 


$UserAccount = Get-LocalUser -Name "test"
$UserAccount | Set-LocalUser -Password $encrypted