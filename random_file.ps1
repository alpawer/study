$FolderPath = "./TestFiles"

if (-not (Test-Path $FolderPath)) {
    New-Item -ItemType Directory -Path $FolderPath | Out-Null
    Write-Host "folder '$FolderPath' was create." -ForegroundColor Cyan 
}

Get-ChildItem -Path $FolderPath -File | Remove-Item 
Write-Host "Folder is clear" -ForegroundColor Cyan
Write-Host ""

$RandomCount = Get-Random -Minimum 1 -Maximum 7

Write-Host "Generating $RandomCount files" -ForegroundColor Yellow
Write-Host ""
 
for ($i = 1; $i -le $RandomCount; $i++) {
    $FileName = "file_$i.txt"
    $FilePath = Join-Path -Path $FolderPath -ChildPath $FileName
    Set-Content -Path $FilePath -Value "Content number $i"
    Write-Host "   made: $FileName" -ForegroundColor Green
} 

Write-Host ""

$FileCount = (Get-ChildItem -Path $FolderPath -File | Measure-Object).Count

Write-Host "We found $FileCount files" -ForegroundColor Cyan

if ($FileCount -eq 6) {
    Write-Host "----------------------" -ForegroundColor Magenta
    Write-Host "Ура Київ за шість днів" -ForegroundColor Magenta
    Write-Host "----------------------" -ForegroundColor Magenta
} else {
    Write-Host "Amount of files is not equal to 6. I am sorry" -ForegroundColor Red
}