[CmdletBinding()]
param(
    [ValidateSet('Status', 'Switch', 'VerifyStatic', 'RunQueries', 'Deploy')]
    [string]$Action = 'Status',

    [ValidateSet('sqlserver', 'postgresql')]
    [string]$TargetEngine,

    [string]$ConfigPath = '',
    [string]$SqlServerInstance = 'localhost',
    [string]$PostgresUser = $(if ($env:PGUSER) { $env:PGUSER } else { 'postgres' })
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
    $ConfigPath = Join-Path $PSScriptRoot 'hotswap_config.json'
}
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$cfg = Get-Content -Raw -Path $ConfigPath -Encoding UTF8 | ConvertFrom-Json

function Show-Status {
    $active = $cfg.active_engine
    $eng = $cfg.engines.$active
    Write-Output "=== BOOK TRACKER HOT-SWAP MANAGER ==="
    Write-Output "Motor Activo   : $active ($($eng.display_name))"
    Write-Output "Tablas Esquema : $($cfg.tables_count)"
    Write-Output "Solo Baja Log. : $($cfg.failover_policy.soft_delete_only)"
    Write-Output "DDL Activo     : $($eng.scripts.ddl)"
    Write-Output "DML Activo     : $($eng.scripts.dml)"
    Write-Output "Consultas AR   : $($eng.scripts.queries)"
    Write-Output "Verificacion   : $($eng.scripts.verify)"
}

function Invoke-StaticParityCheck {
    $sqlDdl = Join-Path $repoRoot $cfg.engines.sqlserver.scripts.ddl
    $pgDdl  = Join-Path $repoRoot $cfg.engines.postgresql.scripts.ddl
    $sqlDml = Join-Path $repoRoot $cfg.engines.sqlserver.scripts.dml
    $pgDml  = Join-Path $repoRoot $cfg.engines.postgresql.scripts.dml

    $sqlTables = (Select-String -Path $sqlDdl -Pattern 'CREATE TABLE').Count
    $pgTables  = (Select-String -Path $pgDdl -Pattern 'CREATE TABLE').Count
    $sqlFks    = (Select-String -Path $sqlDdl -Pattern 'FOREIGN KEY').Count
    $pgFks     = (Select-String -Path $pgDdl -Pattern 'FOREIGN KEY').Count
    $sqlInserts= (Select-String -Path $sqlDml -Pattern '^INSERT INTO').Count
    $pgInserts = (Select-String -Path $pgDml -Pattern '^INSERT INTO').Count
    $pgBadLen  = (Select-String -Path $pgDdl -Pattern '\bLEN\(').Count

    Write-Output "=== AUDITORIA DE PARIDAD ESTATICA MULTI-SGBD ==="
    Write-Output "SQL Server -> Tablas: $sqlTables | FKs: $sqlFks | Inserts: $sqlInserts"
    Write-Output "PostgreSQL -> Tablas: $pgTables | FKs: $pgFks | Inserts: $pgInserts | LEN() residual: $pgBadLen"

    if ($sqlTables -ne 100 -or $pgTables -ne 100 -or $sqlFks -ne 432 -or $pgFks -ne 432 -or $sqlInserts -ne $pgInserts -or $pgBadLen -gt 0) {
        throw "Fallo la auditoria de paridad Multi-SGBD."
    }
    Write-Output "PARIDAD 1:1 VERIFICADA EXITOSAMENTE."
}

function Invoke-EngineScript([string]$engineName, [string]$scriptPath) {
    $fullScript = Join-Path $repoRoot $scriptPath
    if (-not (Test-Path $fullScript)) { throw "No existe script: $fullScript" }
    $eng = $cfg.engines.$engineName
    if ($engineName -eq 'sqlserver') {
        $sqlcmd = Get-Command sqlcmd -ErrorAction SilentlyContinue
        if (-not $sqlcmd) { throw "sqlcmd no esta disponible en PATH." }
        & $sqlcmd.Source -S $SqlServerInstance -E -C -b -i $fullScript
        if ($LASTEXITCODE -ne 0) { throw "Error ejecutando sqlcmd en $fullScript" }
    } else {
        $psql = Get-Command psql -ErrorAction SilentlyContinue
        if (-not $psql) {
            $fallback = 'C:\Program Files\PostgreSQL\18\bin\psql.exe'
            if (Test-Path $fallback) { $psql = Get-Item $fallback }
            else { throw "psql no esta disponible en PATH." }
        }
        $psqlExe = if ($psql -is [System.IO.FileInfo]) { $psql.FullName } else { $psql.Source }
        & $psqlExe -h $eng.host -p $eng.port -U $PostgresUser -d $eng.database -v ON_ERROR_STOP=1 -f $fullScript
        if ($LASTEXITCODE -ne 0) { throw "Error ejecutando psql en $fullScript" }
    }
}

switch ($Action) {
    'Status' {
        Show-Status
    }
    'VerifyStatic' {
        Invoke-StaticParityCheck
    }
    'Switch' {
        if (-not $TargetEngine) { throw "Debe especificar -TargetEngine sqlserver o postgresql." }
        Invoke-StaticParityCheck
        $prev = $cfg.active_engine
        $cfg.active_engine = $TargetEngine
        $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($ConfigPath, ($cfg | ConvertTo-Json -Depth 6), $utf8NoBom)
        Write-Output "Hot-Swap completado: $prev -> $TargetEngine"
        Show-Status
    }
    'Deploy' {
        $engName = if ($TargetEngine) { $TargetEngine } else { $cfg.active_engine }
        $eng = $cfg.engines.$engName
        Invoke-EngineScript $engName $eng.scripts.ddl
        Invoke-EngineScript $engName $eng.scripts.dml
        Invoke-EngineScript $engName $eng.scripts.verify
    }
    'RunQueries' {
        $engName = if ($TargetEngine) { $TargetEngine } else { $cfg.active_engine }
        $eng = $cfg.engines.$engName
        Invoke-EngineScript $engName $eng.scripts.queries
    }
}
