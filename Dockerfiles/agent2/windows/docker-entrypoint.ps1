
# Script trace mode
if ($env:DEBUG_MODE -eq "true") {
    Set-PSDebug -trace 1
}

# Default Zabbix installation name
# Default Zabbix server host
if ([string]::IsNullOrWhitespace($env:ZBX_SERVER_HOST)) {
    $env:ZBX_SERVER_HOST="zabbix-server"
}
# Default Zabbix server port number
if ([string]::IsNullOrWhitespace($env:ZBX_SERVER_PORT)) {
    $env:ZBX_SERVER_PORT="10051"
}


# Default directories
# User 'zabbix' home directory
$ZabbixUserHomeDir="C:\zabbix"
# Configuration files directory
$ZabbixConfigDir="C:\zabbix\conf"

function Update-Config-Var {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string] $ConfigPath,
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$VarName,
        [Parameter(Mandatory=$false, Position=2)]
        [string]$VarValue = $null,
        [Parameter(Mandatory=$false, Position=3)]
        [bool]$IsMultiple
    )

    $MaskList = "TLSPSKIdentity"

    if (-not(Test-Path -Path $ConfigPath -PathType Leaf)) {
        throw "**** Configuration file '$ConfigPath' does not exist"
    }

    if ($MaskList.Contains($VarName) -eq $true -And [string]::IsNullOrWhitespace($VarValue) -ne $true) {
        Write-Host -NoNewline "** Updating '$ConfigPath' parameter ""$VarName"": '****'. Enable DEBUG_MODE to view value ..."
    }
    else {
        Write-Host -NoNewline  "** Updating '$ConfigPath' parameter ""$VarName"": '$VarValue'..."
    }

    if ([string]::IsNullOrWhitespace($VarValue)) {
        if ((Get-Content $ConfigPath | %{$_ -match "^$VarName="}) -contains $true) {
            (Get-Content $ConfigPath) |
                Where-Object {$_ -notmatch "^$VarName=" } |
                Set-Content $ConfigPath
         }

        Write-Host "removed"
        return
    }

    if ($VarValue -eq '""') {
        (Get-Content $ConfigPath) | Foreach-Object { $_ -Replace "^($VarName=)(.*)", '$1' } | Set-Content $ConfigPath
        Write-Host "undefined"
        return
    }

    if ($VarName -match '^TLS.*File$') {
        $VarValue="$ZabbixUserHomeDir\enc\$VarValue"
    }

    if ((Get-Content $ConfigPath | %{$_ -match "^$VarName="}) -contains $true -And $IsMultiple -ne $true) {
        (Get-Content $ConfigPath) | Foreach-Object { $_ -Replace "^$VarName=.+", "$VarName=$VarValue" } | Set-Content $ConfigPath

        Write-Host updated
    }
    elseif ((Get-Content $ConfigPath | select-string -pattern "^[#;] $VarName=").length -gt 1) {
        (Get-Content $ConfigPath) |
            Foreach-Object {
                $_
                if ($_ -match "^[#;] $VarName=$") {
                    "$VarName=$VarValue"
                }
            } | Set-Content $ConfigPath

        Write-Host "added first occurrence"
    }
    elseif ((Get-Content $ConfigPath | select-string -pattern "^[#;] $VarName=").length -gt 0) {
        (Get-Content $ConfigPath) |
            Foreach-Object {
                $_
                if ($_ -match "^[#;] $VarName=") {
                    "$VarName=$VarValue"
                }
            } | Set-Content $ConfigPath

        Write-Host "added"
    }
    else {
    Add-Content -Path $ConfigPath -Value "$VarName=$VarValue"
        Write-Host "added at the end"
    }
}

function Update-Config-Multiple-Var {
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string] $ConfigPath,
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$VarName,
        [Parameter(Mandatory=$false, Position=2)]
        [string]$VarValue = $null
    )

    foreach ($value in $VarValue.split(',')) {
        Update-Config-Var $ConfigPath $VarName $value $true
    }
}

function Prepare-Zbx-Agent-Config {
    Write-Host "** Preparing Zabbix agent 2 configuration file"

    $ZbxAgentConfig="$ZabbixConfigDir\zabbix_agent2.conf"

    if ([string]::IsNullOrWhitespace($env:ZBX_PASSIVESERVERS)) {
        $env:ZBX_PASSIVESERVERS=""
    }
    else {
        $env:ZBX_PASSIVESERVERS=",$env:ZBX_PASSIVESERVERS"
    }

    $env:ZBX_PASSIVESERVERS=$env:ZBX_SERVER_HOST + $env:ZBX_PASSIVESERVERS

    if ([string]::IsNullOrWhitespace($env:ZBX_ACTIVESERVERS)) {
        $env:ZBX_ACTIVESERVERS=""
    }
    else {
        $env:ZBX_ACTIVESERVERS=",$env:ZBX_ACTIVESERVERS"
    }

    $env:ZBX_ACTIVESERVERS=$env:ZBX_SERVER_HOST + ":" + $env:ZBX_SERVER_PORT + $env:ZBX_ACTIVESERVERS

    Update-Config-Var $ZbxAgentConfig "LogType" "console"
    Update-Config-Var $ZbxAgentConfig "LogFile"
    Update-Config-Var $ZbxAgentConfig "LogFileSize"
    Update-Config-Var $ZbxAgentConfig "DebugLevel" "$env:ZBX_DEBUGLEVEL"
    Update-Config-Var $ZbxAgentConfig "SourceIP"

    if ([string]::IsNullOrWhitespace($env:ZBX_PASSIVE_ALLOW)) {
        $env:ZBX_PASSIVE_ALLOW="true"
    }

    if ($env:ZBX_PASSIVE_ALLOW -eq "true") {
        Write-Host  "** Using '$env:ZBX_PASSIVESERVERS' servers for passive checks"
        Update-Config-Var $ZbxAgentConfig "Server" "$env:ZBX_PASSIVESERVERS"
    }
    else {
        Update-Config-Var $ZbxAgentConfig "Server"
    }

    Update-Config-Var $ZbxAgentConfig "ListenPort" "$env:ZBX_LISTENPORT"
    Update-Config-Var $ZbxAgentConfig "ListenIP" "$env:ZBX_LISTENIP"

    if ([string]::IsNullOrWhitespace($env:ZBX_ACTIVE_ALLOW)) {
        $env:ZBX_ACTIVE_ALLOW="true"
    }

    if ($env:ZBX_PASSIVE_ALLOW -eq "true") {
        Write-Host "** Using '$env:ZBX_ACTIVESERVERS' servers for active checks"
        Update-Config-Var $ZbxAgentConfig "ServerActive" "$env:ZBX_ACTIVESERVERS"
    }
    else {
        Update-Config-Var $ZbxAgentConfig "ServerActive"
    }
    Update-Config-Var $ZbxAgentConfig "ForceActiveChecksOnStart" "$env:ZBX_FORCEACTIVECHECKSONSTART"

    if ([string]::IsNullOrWhitespace($env:ZBX_ENABLEPERSISTENTBUFFER)) {
        $env:ZBX_ENABLEPERSISTENTBUFFER="true"
    }

    if ($env:ZBX_ENABLEPERSISTENTBUFFER -eq "true") {
        Update-Config-Var $ZbxAgentConfig "EnablePersistentBuffer" "1"
        Update-Config-Var $ZbxAgentConfig "PersistentBufferFile" "$ZabbixUserHomeDir\buffer\agent2.db"
        Update-Config-Var $ZbxAgentConfig "PersistentBufferPeriod" "$env:ZBX_PERSISTENTBUFFERPERIOD"
    }
    else {
        Update-Config-Var $ZbxAgentConfig "EnablePersistentBuffer" "0"
    }

    if ([string]::IsNullOrWhitespace($env:ZBX_ENABLESTATUSPORT)) {
        $env:ZBX_ENABLESTATUSPORT="true"
    }

    if ($env:ZBX_ENABLESTATUSPORT -eq "true") {
        Update-Config-Var $ZbxAgentConfig "StatusPort" "31999"
    }

    Update-Config-Var $ZbxAgentConfig "Hostname" "$env:ZBX_HOSTNAME"
    Update-Config-Var $ZbxAgentConfig "HostnameItem" "$env:ZBX_HOSTNAMEITEM"
    Update-Config-Var $ZbxAgentConfig "HostMetadata" "$env:ZBX_METADATA"
    Update-Config-Var $ZbxAgentConfig "HostMetadataItem" "$env:ZBX_METADATAITEM"
    Update-Config-Var $ZbxAgentConfig "HostInterface" "$env:ZBX_HOSTINTERFACE"
    Update-Config-Var $ZbxAgentConfig "HostInterfaceItem" "$env:ZBX_HOSTINTERFACEITEM"
    Update-Config-Var $ZbxAgentConfig "RefreshActiveChecks" "$env:ZBX_REFRESHACTIVECHECKS"
    Update-Config-Var $ZbxAgentConfig "BufferSend" "$env:ZBX_BUFFERSEND"
    Update-Config-Var $ZbxAgentConfig "BufferSize" "$env:ZBX_BUFFERSIZE"
    # Please use include to enable Alias feature
#    update_config_multiple_var $ZBX_AGENT_CONFIG "Alias" $env:ZBX_ALIAS
    # Please use include to enable Perfcounter feature
#    update_config_multiple_var $ZBX_AGENT_CONFIG "PerfCounter" $env:ZBX_PERFCOUNTER
    Update-Config-Var $ZbxAgentConfig "Timeout" "$env:ZBX_TIMEOUT"
    Update-Config-Var $ZbxAgentConfig "Include" ".\zabbix_agent2.d\plugins.d\*.conf"
    Update-Config-Var $ZbxAgentConfig "Include" ".\zabbix_agentd.d\*.conf" $true
    Update-Config-Var $ZbxAgentConfig "UnsafeUserParameters" "$env:ZBX_UNSAFEUSERPARAMETERS"
    Update-Config-Var $ZbxAgentConfig "UserParameterDir" "$ZabbixUserHomeDir\user_scripts\"
    Update-Config-Var $ZbxAgentConfig "TLSConnect" "$env:ZBX_TLSCONNECT"
    Update-Config-Var $ZbxAgentConfig "TLSAccept" "$env:ZBX_TLSACCEPT"
    Update-Config-Var $ZbxAgentConfig "TLSCAFile" "$env:ZBX_TLSCAFILE"
    Update-Config-Var $ZbxAgentConfig "TLSCRLFile" "$env:ZBX_TLSCRLFILE"
    Update-Config-Var $ZbxAgentConfig "TLSServerCertIssuer" "$env:ZBX_TLSSERVERCERTISSUER"
    Update-Config-Var $ZbxAgentConfig "TLSServerCertSubject" "$env:ZBX_TLSSERVERCERTSUBJECT"
    Update-Config-Var $ZbxAgentConfig "TLSCertFile" "$env:ZBX_TLSCERTFILE"
    Update-Config-Var $ZbxAgentConfig "TLSCipherAll" "$env:ZBX_TLSCIPHERALL"
    Update-Config-Var $ZbxAgentConfig "TLSCipherAll13" "$env:ZBX_TLSCIPHERALL13"
    Update-Config-Var $ZbxAgentConfig "TLSCipherCert" "$env:ZBX_TLSCIPHERCERT"
    Update-Config-Var $ZbxAgentConfig "TLSCipherCert13" "$env:ZBX_TLSCIPHERCERT13"
    Update-Config-Var $ZbxAgentConfig "TLSCipherPSK" "$env:ZBX_TLSCIPHERPSK"
    Update-Config-Var $ZbxAgentConfig "TLSCipherPSK13" "$env:ZBX_TLSCIPHERPSK13"
    Update-Config-Var $ZbxAgentConfig "TLSKeyFile" "$env:ZBX_TLSKEYFILE"
    Update-Config-Var $ZbxAgentConfig "TLSPSKIdentity" "$env:ZBX_TLSPSKIDENTITY"
    Update-Config-Var $ZbxAgentConfig "TLSPSKFile" "$env:ZBX_TLSPSKFILE"

    Update-Config-Multiple-Var $ZbxAgentConfig "DenyKey" "$env:ZBX_DENYKEY"
    Update-Config-Multiple-Var $ZbxAgentConfig "AllowKey" "$env:ZBX_ALLOWKEY"

}

function Prepare-Zbx-Agent-Plugins-Config {
    Write-Host "** Preparing Zabbix agent 2 (plugins) configuration files"

    Update-Config-Var "$ZabbixConfigDir\zabbix_agent2.d\plugins.d\mongodb.conf" "Plugins.MongoDB.System.Path" "$ZabbixUserHomeDir\zabbix-agent2-plugin\mongodb.exe"
    Update-Config-Var "$ZabbixConfigDir\zabbix_agent2.d\plugins.d\postgresql.conf" "Plugins.PostgreSQL.System.Path" "$ZabbixUserHomeDir\zabbix-agent2-plugin\postgresql.exe"
    Update-Config-Var "$ZabbixConfigDir\zabbix_agent2.d\plugins.d\mssql.conf" "Plugins.MSSQL.System.Path" "$ZabbixUserHomeDir\zabbix-agent2-plugin\mssql.exe"
    Update-Config-Var "$ZabbixConfigDir\zabbix_agent2.d\plugins.d\ember.conf" "Plugins.EmberPlus.System.Path" "$ZabbixUserHomeDir\zabbix-agent2-plugin\ember-plus.exe"
}

function PrepareAgent {
    Write-Host "** Preparing Zabbix agent 2"
    Prepare-Zbx-Agent-Config
    Prepare-Zbx-Agent-Plugins-Config
}

$commandArgs=$args

if ($args.length -gt 0 -And $args[0].Substring(0, 1) -eq '-') {
    $commandArgs = "C:\zabbix\sbin\zabbix_agent2.exe " + $commandArgs
}

if ($args.length -gt 0 -And $args[0] -eq "C:\zabbix\sbin\zabbix_agent2.exe") {
    PrepareAgent
}

if ($args.length -gt 0) {
    Invoke-Expression "$CommandArgs"
}
