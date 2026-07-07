Connect-MgGraph -Scopes "Policy.Read.All","Policy.ReadWrite.ConditionalAccess"

$regions = @(
    @{DisplayName = "Northern Africa"; CountriesAndRegions = @("DZ","EG","EH","LY","MA","SD","TN")},
    @{DisplayName = "Eastern Africa"; CountriesAndRegions = @("IO","BI","KM","DJ","ER","ET","TF","KE","MG","MW","YT","MZ","RE","RW","SC","SO","SS","UG","TZ","ZM","ZW")},
    @{DisplayName = "Middle Africa"; CountriesAndRegions = @("AO","CM","CF","TD","CG","CD","GQ","GA","ST")},
    @{DisplayName = "Southern Africa"; CountriesAndRegions = @("BW","SZ","LS","NA","ZA")},
    @{DisplayName = "Western Africa"; CountriesAndRegions = @("BJ","BF","CV","CI","GM","GH","GN","GW","LR","ML","MR","NE","NG","SH","SN","SL","TG")},
    @{DisplayName = "Caribbean"; CountriesAndRegions = @("AI","AG","AW","BS","BB","BQ","BQ","VG","KY","CU","CW","DM","DO","GD","GP","HT","JM","MQ","MS","PR","BL","KN","LC","MF","VC","SX","TT","TC","VI")},
    @{DisplayName = "Central America"; CountriesAndRegions = @("BZ","CR","SV","GT","HN","MX","NI","PA")},
    @{DisplayName = "South America"; CountriesAndRegions = @("AR","BO","BV","BR","CL","CO","EC","FK","GF","GY","PY","PE","GS","SR","UY","VE")},
    @{DisplayName = "Northern America"; CountriesAndRegions = @("BM","CA","GL","PM","US")},
    @{DisplayName = "Central Asia"; CountriesAndRegions = @("KZ","KG","TJ","TM","UZ")},
    @{DisplayName = "Eastern Asia"; CountriesAndRegions = @("CN","HK","MO","KP","JP","MN","KR")},
    @{DisplayName = "South-eastern Asia"; CountriesAndRegions = @("BN","KH","ID","LA","MY","MM","PH","SG","TH","TL","VN")},
    @{DisplayName = "Southern Asia"; CountriesAndRegions = @("AF","BD","BT","IN","IR","MV","NP","PK","LK")},
    @{DisplayName = "Western Asia"; CountriesAndRegions = @("AM","AZ","BH","CY","GE","IQ","IL","JO","KW","LB","OM","QA","SA","PS","SY","TR","AE","YE")},
    @{DisplayName = "Eastern Europe"; CountriesAndRegions = @("BY","BG","CZ","HU","PL","MD","RO","SK","UA")},
    @{DisplayName = "Russia"; CountriesAndRegions = @("RU")},
    @{DisplayName = "Northern Europe"; CountriesAndRegions = @("AX","DK","EE","FO","FI","IS","IE","IM","LV","LT","NO","SJ","SE","GB","GG","JE")},
    @{DisplayName = "Southern Europe"; CountriesAndRegions = @("AL","AD","BA","HR","GI","GR","VA","IT","MT","ME","MK","PT","SM","RS","SI","ES")},
    @{DisplayName = "Western Europe"; CountriesAndRegions = @("AT","BE","FR","DE","LI","LU","MC","NL","CH")},
    @{DisplayName = "Australia"; CountriesAndRegions = @("AU")},
    @{DisplayName = "New Zealand"; CountriesAndRegions = @("NZ")},
    @{DisplayName = "Australian Neighbouring Islands"; CountriesAndRegions = @("CX","CC","HM","NF")},
    @{DisplayName = "Melanesia"; CountriesAndRegions = @("FJ","NC","PG","SB","VU")},
    @{DisplayName = "Micronesia"; CountriesAndRegions = @("GU","KI","MH","FM","NR","MP","PW","UM")},
    @{DisplayName = "Polynesia"; CountriesAndRegions = @("AS","CK","PF","NU","PN","WS","TK","TO","TV","WF")}
)

$getLocations = Get-MgIdentityConditionalAccessNamedLocation -All

foreach ($region in $regions) {
    $existingLocation = $getLocations | Where-Object { $_.DisplayName -eq $region.DisplayName }

    if ($null -eq $existingLocation) {
        $countries = $region.CountriesAndRegions | Sort-Object -Unique

        $params = @{
            "@odata.type" = "#microsoft.graph.countryNamedLocation"
            displayName = $region.DisplayName
            countriesAndRegions = $countries
            includeUnknownCountriesAndRegions = $false
        }

        New-MgIdentityConditionalAccessNamedLocation -BodyParameter $params | Out-Null
        Write-Host "$($region.DisplayName) created"
    }
    else {
        Write-Host "$($region.DisplayName) already exists in this tenant"
    }
}

Disconnect-MgGraph
