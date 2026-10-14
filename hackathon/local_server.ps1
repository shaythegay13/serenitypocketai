# Simple HTTP Server for Local Development
# This script creates a basic HTTP server to serve your application locally

$port = 3000
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()

Write-Host "🚀 Starting local server for Responsible Betting Advisor" -ForegroundColor Green
Write-Host "📡 Server running at: http://localhost:$port" -ForegroundColor Blue
Write-Host "📁 Serving files from: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Red
Write-Host ""

# MIME types for different file extensions
$mimeTypes = @{
    '.html' = 'text/html'
    '.css'  = 'text/css'
    '.js'   = 'application/javascript'
    '.json' = 'application/json'
    '.png'  = 'image/png'
    '.jpg'  = 'image/jpeg'
    '.gif'  = 'image/gif'
    '.svg'  = 'image/svg+xml'
    '.ico'  = 'image/x-icon'
}

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        # Get the requested path
        $localPath = $request.Url.LocalPath
        if ($localPath -eq '/') { $localPath = '/index.html' }
        $filePath = ".$(Join-Path $localPath)"
        
        Write-Host "$(Get-Date -Format 'HH:mm:ss') - Request: $($request.Url)" -ForegroundColor Gray
        
        # Security: Only serve files from current directory
        $fullPath = Resolve-Path $filePath -ErrorAction SilentlyContinue
        if ($fullPath -and (Test-Path $fullPath) -and (Split-Path $fullPath) -like "$(Get-Location)*") {
            try {
                $fileContent = [System.IO.File]::ReadAllBytes($fullPath)
                $contentType = $mimeTypes[[System.IO.Path]::GetExtension($fullPath).ToLower()]
                if ($contentType) {
                    $response.ContentType = $contentType
                } else {
                    $response.ContentType = 'application/octet-stream'
                }
                $response.ContentLength64 = $fileContent.Length
                $response.OutputStream.Write($fileContent, 0, $fileContent.Length)
                Write-Host "✅ Served: $localPath" -ForegroundColor Green
            }
            catch {
                $response.StatusCode = 500
                $errorMessage = "Error reading file: $($_.Exception.Message)"
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($errorMessage)
                $response.ContentLength64 = $buffer.Length
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
                Write-Host "❌ Error: $localPath - $($_.Exception.Message)" -ForegroundColor Red
            }
        }
        else {
            $response.StatusCode = 404
            $errorMessage = "File not found: $localPath"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($errorMessage)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            Write-Host "❌ Not found: $localPath" -ForegroundColor Red
        }
        
        $response.OutputStream.Close()
    }
}
catch {
    Write-Host "❌ Server error: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    $listener.Stop()
    $listener.Close()
    Write-Host "🛑 Server stopped" -ForegroundColor Yellow
}