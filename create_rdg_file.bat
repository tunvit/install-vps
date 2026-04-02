@echo off
setlocal

set SERVER_NAME=127.0.0.1
set SERVER_PORT=1102
set SERVER_USERNAME=administrator
set SERVER_PASSWORD=password
set OUTPUT_FILE=%SERVER_NAME:.=_%
set OUTPUT_FILE=%OUTPUT_FILE%.rdg
set PS1=%~dp0~temp_rdg.ps1

(
    echo Add-Type -AssemblyName System.Security
    echo $bytes = [System.Text.Encoding]::Unicode.GetBytes('%SERVER_PASSWORD%'^)
    echo $enc = [System.Security.Cryptography.ProtectedData]::Protect($bytes, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser^)
    echo $pass = [Convert]::ToBase64String($enc^)
    echo $xml = New-Object System.Xml.XmlDocument
    echo $xml.AppendChild($xml.CreateXmlDeclaration('1.0', 'utf-8', $null^)^) ^| Out-Null
    echo $root = $xml.CreateElement('RDCMan'^); $root.SetAttribute('programVersion','2.93'^); $root.SetAttribute('schemaVersion','3'^); $xml.AppendChild($root^) ^| Out-Null
    echo $file = $xml.CreateElement('file'^); $root.AppendChild($file^) ^| Out-Null
    echo $file.AppendChild($xml.CreateElement('credentialsProfiles'^)^) ^| Out-Null
    echo $props = $xml.CreateElement('properties'^); $file.AppendChild($props^) ^| Out-Null
    echo $exp = $xml.CreateElement('expanded'^); $exp.InnerText = 'True'; $props.AppendChild($exp^) ^| Out-Null
    echo $name = $xml.CreateElement('name'^); $name.InnerText = '%SERVER_NAME%'; $props.AppendChild($name^) ^| Out-Null
    echo $server = $xml.CreateElement('server'^); $file.AppendChild($server^) ^| Out-Null
    echo $sp = $xml.CreateElement('properties'^); $server.AppendChild($sp^) ^| Out-Null
    echo $sn = $xml.CreateElement('name'^); $sn.InnerText = '%SERVER_NAME%'; $sp.AppendChild($sn^) ^| Out-Null
    echo $cred = $xml.CreateElement('logonCredentials'^); $cred.SetAttribute('inherit','None'^); $server.AppendChild($cred^) ^| Out-Null
    echo $pn = $xml.CreateElement('profileName'^); $pn.SetAttribute('scope','Local'^); $pn.InnerText = 'Custom'; $cred.AppendChild($pn^) ^| Out-Null
    echo $un = $xml.CreateElement('userName'^); $un.InnerText = '%SERVER_USERNAME%'; $cred.AppendChild($un^) ^| Out-Null
    echo $pw = $xml.CreateElement('password'^); $pw.InnerText = $pass; $cred.AppendChild($pw^) ^| Out-Null
    echo $dm = $xml.CreateElement('domain'^); $dm.InnerText = '%SERVER_NAME%'; $cred.AppendChild($dm^) ^| Out-Null
    echo $conn = $xml.CreateElement('connectionSettings'^); $conn.SetAttribute('inherit','None'^); $server.AppendChild($conn^) ^| Out-Null
    echo $cc = $xml.CreateElement('connectToConsole'^); $cc.InnerText = 'False'; $conn.AppendChild($cc^) ^| Out-Null
    echo $conn.AppendChild($xml.CreateElement('startProgram'^)^) ^| Out-Null
    echo $conn.AppendChild($xml.CreateElement('workingDir'^)^) ^| Out-Null
    echo $pt = $xml.CreateElement('port'^); $pt.InnerText = '%SERVER_PORT%'; $conn.AppendChild($pt^) ^| Out-Null
    echo $conn.AppendChild($xml.CreateElement('loadBalanceInfo'^)^) ^| Out-Null
    echo $rd = $xml.CreateElement('remoteDesktop'^); $rd.SetAttribute('inherit','None'^); $server.AppendChild($rd^) ^| Out-Null
    echo $sz = $xml.CreateElement('sameSizeAsClientArea'^); $sz.InnerText = 'True'; $rd.AppendChild($sz^) ^| Out-Null
    echo $fs = $xml.CreateElement('fullScreen'^); $fs.InnerText = 'False'; $rd.AppendChild($fs^) ^| Out-Null
    echo $cd = $xml.CreateElement('colorDepth'^); $cd.InnerText = '24'; $rd.AppendChild($cd^) ^| Out-Null
    echo $root.AppendChild($xml.CreateElement('connected'^)^) ^| Out-Null
    echo $root.AppendChild($xml.CreateElement('favorites'^)^) ^| Out-Null
    echo $root.AppendChild($xml.CreateElement('recentlyUsed'^)^) ^| Out-Null
    echo $xml.Save('%~dp0%OUTPUT_FILE%'^)
    echo Write-Host 'Done! Saved as %OUTPUT_FILE%'
) > "%PS1%"

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
del "%PS1%"

echo.
pause
endlocal
