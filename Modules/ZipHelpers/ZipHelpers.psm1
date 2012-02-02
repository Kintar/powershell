##########################################################
# Zip functionality for powershell
##########################################################

#######################################################################
# Locates the 7z executable in the module directory
#######################################################################
function find7Zip
{
    $path = $myInvocation.MyCommand.Module.ModuleBase
    $zipCmd = $path + "\7z.exe"
    return $zipCmd
}

#######################################################################
# Creates a zip file from the file objects in the pipeline, and returns
# the created item
#######################################################################
function Create-Zip([string]$fileName)
{
    $zipCmd = find7Zip
    $filenameList = ""
    foreach ($file in $input)
    {
        $filenameList += ($file.FullName + " ")
    }
    
    iex "$zipCmd a $fileName $filenameList"
    return Get-Item($fileName)
}


function Extract-Zip([string]$zipFile, [string]$target = "")
{
    $outArg = ""
    if ($target -ne "")
    {
        $outArg = "-o " + $target
    }
    
    if (-not (Test-Path($zipFile)))
    {
        $zipFile = $zipFile + ".zip"
        if (-not (Test-Path($zipFile)))
        {
            Write-Host("Zip file '$zipFile' not found") -foregroundcolor red
            return $false
        }
    }
    
    $zipCmd = find7Zip
    
    $result = (iex "$zipCmd x -y $outArg $zipFile")
    foreach($line in $result)
    {
        if ($line.Contains("Everything is Ok")) 
        {
            return $true
        }
    }
    
    return $false
}

Export-ModuleMember Create-Zip, Extract-Zip
# SIG # Begin signature block
# MIIQIgYJKoZIhvcNAQcCoIIQEzCCEA8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUmZ1LnRIAjlCK1d6y+rcjF6Ka
# UJugggxLMIIFoTCCBUugAwIBAgIBAjANBgkqhkiG9w0BAQUFADCBwzELMAkGA1UE
# BhMCVVMxEjAQBgNVBAgTCVRlbm5lc3NlZTESMBAGA1UEBxMJTmFzaHZpbGxlMRMw
# EQYDVQQKEwpFRlQgU291cmNlMSMwIQYDVQQLExpSb290IENlcnRpZmljYXRlIEF1
# dGhvcml0eTEeMBwGA1UEAxMVcm9vdC1jYS5lZnRzb3VyY2UuY29tMTIwMAYJKoZI
# hvcNAQkBFiNjZXJ0aWZpY2F0ZS5hdXRob3JpdHlAZWZ0c291cmNlLmNvbTAeFw0w
# ODEyMjQxODM0NDJaFw0xMTEyMjQxODM0NDJaMIG2MQswCQYDVQQGEwJVUzESMBAG
# A1UECBMJVGVubmVzc2VlMRMwEQYDVQQKEwpFRlQgU291cmNlMSswKQYDVQQLEyJJ
# bnRlcm1lZGlhdGUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MR0wGwYDVQQDExRtaWQt
# Y2EuZWZ0ZG9tYWluLm5ldDEyMDAGCSqGSIb3DQEJARYjY2VydGlmaWNhdGUuYXV0
# aG9yaXR5QGVmdGRvbWFpbi5uZXQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQDOWWiXwnEGdOeWwhXomKoV/+KC6F8Q+qVctpVTG9OsvonhU3OyEaPaqRz2
# a+kL+thUj3lmcpUWIC6I7JzfHEEFeNEGqLjrzAMjeFJxUvF+A9+3bvXFVBAOqMg4
# 4JePp0TsU9OqCvaG9fl+uL3t5VJd7htkOkVjn3wyl0C1/27ekrEYUHsL68/hx3EV
# fU0l/LZQET7WVmd9Cu17XK+f0Th5lkozUlc2FhlvkPU6uu4JG+AUEOJ1WVxkGXN3
# eEB2j46NQghgsDuwq5RUDQs+rx7DdI50xTWNfosuItJ9Wfz3dVlx11wZ82Mihp7h
# u0+Ck2lI8mmzIJB3pPOQtBGhwbMCBh1ACJYG5Ej/FAziZ3G3TY1jZSLOlIZ8N2W0
# vM7riB8iRDdhQMbT5zCbtaRYC/VCe5AiOgTSLAmBLylq9jinpFipFc6yHDKCZlx1
# cIRItwt+osz0BKK4VZ+XZe/LtWTt814v12cMoflwCYK2La/CSi5cR+x2neA0wuY8
# CL5y04Y2AFJ9LnD+nvHghbqhQobLsRByNU3MUdJIaeDj3NiQOs1RS+zlmtGTPD2I
# GV6BjhXH9lVLlYD4HS5k4Cm7aag740wNPsBAsl4iR33s9VaNJe5oSEZ7uO3/RKTk
# qQtCcmjQbChODLlcdvgSpEG4GGOpnW11e1D8VqV/O0chARqwPwIDAQABo4IBazCC
# AWcwHQYDVR0OBBYEFEPcuzK30pH8aLP0r7WNwMkzsrqkMIH4BgNVHSMEgfAwge2A
# FH+2jK5Gfqml8Ihhv2CvwX8f9DwcoYHJpIHGMIHDMQswCQYDVQQGEwJVUzESMBAG
# A1UECBMJVGVubmVzc2VlMRIwEAYDVQQHEwlOYXNodmlsbGUxEzARBgNVBAoTCkVG
# VCBTb3VyY2UxIzAhBgNVBAsTGlJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MR4w
# HAYDVQQDExVyb290LWNhLmVmdHNvdXJjZS5jb20xMjAwBgkqhkiG9w0BCQEWI2Nl
# cnRpZmljYXRlLmF1dGhvcml0eUBlZnRzb3VyY2UuY29tggkAn3F2z9TUppswDAYD
# VR0TBAUwAwEB/zA9BglghkgBhvhCAQQEMBYuaHR0cHM6Ly9wa2kuZWZ0c291cmNl
# LmNvbS9lZnRzb3VyY2UuY29tX0NBLmNybDANBgkqhkiG9w0BAQUFAANBAMo4pbi0
# OF5iHRYb0IwLV5viSbKv2y+om/fiPyf06CxEXXwXyVpyAjdFjgVB7CpvK04n1XLy
# x2oKUD75YuI7jdkwggaiMIIEiqADAgECAgIBNjANBgkqhkiG9w0BAQUFADCBtjEL
# MAkGA1UEBhMCVVMxEjAQBgNVBAgTCVRlbm5lc3NlZTETMBEGA1UEChMKRUZUIFNv
# dXJjZTErMCkGA1UECxMiSW50ZXJtZWRpYXRlIENlcnRpZmljYXRlIEF1dGhvcml0
# eTEdMBsGA1UEAxMUbWlkLWNhLmVmdGRvbWFpbi5uZXQxMjAwBgkqhkiG9w0BCQEW
# I2NlcnRpZmljYXRlLmF1dGhvcml0eUBlZnRkb21haW4ubmV0MB4XDTExMTAxOTE3
# MjExNVoXDTE2MTAxNzE3MjExNVowgbAxCzAJBgNVBAYTAlVTMRIwEAYDVQQIEwlU
# ZW5uZXNzZWUxEjAQBgNVBAcTCU5hc2h2aWxsZTEXMBUGA1UEChMORUZUU291cmNl
# LCBJbmMxFDASBgNVBAsTC0RldmVsb3BtZW50MR4wHAYDVQQDExVFRlRTb3VyY2Ug
# RGV2ZWxvcG1lbnQxKjAoBgkqhkiG9w0BCQEWG2l0X2RldmVsb3BlcnNAZWZ0c291
# cmNlLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMPFP+oKKAdo
# VFaNU2RtpXgDRzHxTPmI49UcssUIlwYySIGIRBFjgW1apNXuGiZneKL0JbawDhB2
# i/ZMJ3OHhHTCCT0g4I8nzZWuRrniJROv7Wu4D+BgSaS7aGuub0lEF0Q+tyFUO/MA
# +3itKtf3oQsdllEDNOslCFechCaZUQL83jVXZQoAmHKyJwCD+qF284vAJFwVjya+
# kLJohXiT+BbVtV1sXRqI+ae1mWPw24KtVGYhp5OxChYkXB01drz8j/yk+4gO7BGz
# eLmdtQWhrNBCKgcwUToIFQ7/KaDKswka7eg/1nt1fYki+vFepD2VQ1c50Tm3xMGA
# iHLFh+fu4NIVB9OwNRKWfLTDyW2BBSHBLnvyZyFno48dUdoxVrPEfY3OqPlfNjia
# TX9HLSr9LkUPy8ucrFDRHzH4wO0RfR5iKcZESGWNqkA2Z+yKDx6b+OorCdAoiJXr
# Gbo1CUVJDbPQhxXw8ksO1GJfve09cgpGqzjXeVcmDQIANKov0eh4nb3fLgL6mZzP
# Nkzro3d0A8cGQkO/Pbhjd45C7cTtOFzvzgV7FrBdxfvQbTzGfKuptvgqgf45bO28
# QbVzn074J9AqG4H81y93tfqeal9FWsGp0gdw137O2M4KcDrfLzVqC8hu0B2LpTrN
# m0BNdkQgAONdWyVZFZ3XfRjMrdmQEIEFAgMBAAGjgb0wgbowCQYDVR0TBAIwADAs
# BglghkgBhvhCAQ0EHxYdT3BlblNTTCBHZW5lcmF0ZWQgQ2VydGlmaWNhdGUwHQYD
# VR0OBBYEFPvgbAYXCE9ZY4h/MUUrXsn8pxGnMB8GA1UdIwQYMBaAFEPcuzK30pH8
# aLP0r7WNwMkzsrqkMD8GCWCGSAGG+EIBBAQyFjBodHRwOi8vcGtpLmVmdHNvdXJj
# ZS5jb20vbWlkLWNhLmVmdGRvbWFpLm5ldC5jcmwwDQYJKoZIhvcNAQEFBQADggIB
# ALk/7kvTgx/Wzjo5L0vupuo+0lu24sHgBFF3cvmNbxSzWywwApiH9JDMo2kFHqfY
# BKIg2eaHzMrSpBIoHDyqY0GYqWiPOR3YjZQ5DzfiqJ2vhw802/4IJjW21GprzR1r
# jJdxgexaFkSb/EysiWN2iXtjbHfr/dYY+hv5PoLfzbVsPtJr9GYZCmqotmQMTnEJ
# 6CUk+mSyXJ00AqE4xiJHB4jY/ddGGH1dOqxIaxyEhnz7k1/JEW2vOooBZCFPdrck
# jvZf+nR4TR4CZzKOccKbkPZcREbtvhkzMGkGeZ6R4svXnjz9QIC9US0ytpRbokqe
# 55S2NyMItPLYI0DTmAlq6dYYq3/DsnFM7TTCEvAz/wMIwEChj+1zkGjsLqrTI9zO
# bfJEjqhPxKp6g5K7vG5B4KunvqZPSgGU1jjs9/T4ss/XMAKW9htL0CR0jxXoWIwj
# 5i9WFs4N3OgeQd71Joog0Q39Tabc+JNbZH2kUEIX8ih4HUDxodPKde2t0GLp80wy
# 083CBDRMwsst0jccndJApoVP4nxQDbCyIbfxJ4vIua05ZeMaNfodSAqOzpJYmElD
# NtTY+zmbUAyMUOWDl9xiVqnoud06xEX7gXxOwEyDDX167nhLnsyaJchaoh3eYO4e
# G2P+ahK6MSHSKlp351kqsnciVpRxqzay/cgdlpwV67ziMYIDQTCCAz0CAQEwgb0w
# gbYxCzAJBgNVBAYTAlVTMRIwEAYDVQQIEwlUZW5uZXNzZWUxEzARBgNVBAoTCkVG
# VCBTb3VyY2UxKzApBgNVBAsTIkludGVybWVkaWF0ZSBDZXJ0aWZpY2F0ZSBBdXRo
# b3JpdHkxHTAbBgNVBAMTFG1pZC1jYS5lZnRkb21haW4ubmV0MTIwMAYJKoZIhvcN
# AQkBFiNjZXJ0aWZpY2F0ZS5hdXRob3JpdHlAZWZ0ZG9tYWluLm5ldAICATYwCQYF
# Kw4DAhoFAKBaMBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkD
# MQwGCisGAQQBgjcCAQQwIwYJKoZIhvcNAQkEMRYEFFLfRXcZaQyQWxDn6TI+cj6B
# nEv+MA0GCSqGSIb3DQEBAQUABIICAF4Ds/h8qRvAnlkJRYJHS/Eba5VEOkGBv+li
# xDUjuZwuPivdrW2wUwGk59D5l1FgDu8h/itwKEOlk/sgBbTFFt9d2ilTFYcUonvo
# 6ws9BSzdPW0yVV73dZVCOlXMMVkWGtB9NkiOrqi5X0Ggeo0UJs9NJqHCq+JePR/E
# 0Z5BOG8MNxOnlX/5YaGF+z7s9NrLIPu9Z7AFKMM9j3btdgsME2wrOx2OuKDS8gjG
# v1kiCZh0M5TtPK3nDKM6RzQyPFr6CDPzveSbFzHKEF2GfMFY1o6US1fffaCHi7+8
# qg1ko7ZotVsUFmF8f92zNw46LQsFG2kOSurafdhaTHgo12Xz+ZxQI3LtimCR4Lvo
# POv2GH4SnVnaIPjy9Qb/UZ3tFVsPEU1wu3xp/qlAsDUTHeqkZSYPTJ7T5bQRVKrE
# B8pmBs3qe/9iiVDAvjzgD+sawElpmHu4Jo/yNMycDq4LoYF9T8kKUmyIOhcWWvao
# gsUWynbGTrvjpeDFI21KGiPfh1yi5L31E+r6noR9CTxO1yiBDajazEq5OTPDD9CS
# 3ZhLb07ZONjKfeMx00IOgJJWm05d8Av1ucmgCeXg6VXjUpyg/kjDCPnfeyXpYrRG
# bRN702RwoMyd7gx47lAOzC9VZzeI6gjzD8vYUEKTwdTeR2wZvtMwdWcj2TaXnRIo
# 50CVTlrQ
# SIG # End signature block
