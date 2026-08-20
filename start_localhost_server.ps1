param([int]$Port = 8080)

$root = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Prefixes.Add("http://127.0.0.1:$Port/")

try {
  $listener.Start()
  Write-Host "=========================================================="
  Write-Host "  Gesture 3D Viewer Server RUNNING ON:"
  Write-Host "  -> http://localhost:$Port/"
  Write-Host "=========================================================="
} catch {
  Write-Host "Error starting listener: $_"
  exit 1
}

$mimeTypes = @{
  ".html" = "text/html; charset=utf-8";
  ".htm"  = "text/html; charset=utf-8";
  ".js"   = "application/javascript; charset=utf-8";
  ".css"  = "text/css; charset=utf-8";
  ".json" = "application/json; charset=utf-8";
  ".png"  = "image/png";
  ".jpg"  = "image/jpeg";
  ".jpeg" = "image/jpeg";
  ".svg"  = "image/svg+xml";
  ".ico"  = "image/x-icon";
  ".fbx"  = "application/octet-stream";
  ".glb"  = "model/gltf-binary";
  ".gltf" = "model/gltf+json"
}

while ($listener.IsListening) {
  try {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $response.AddHeader("Access-Control-Allow-Origin", "*")
    $response.AddHeader("Cache-Control", "no-cache, no-store, must-revalidate")

    $urlPath = $request.Url.LocalPath.TrimStart('/')
    if ([string]::IsNullOrWhiteSpace($urlPath)) { $urlPath = "index.html" }

    $filePath = Join-Path $root $urlPath

    if (Test-Path $filePath -PathType Leaf) {
      $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
      $contentType = $mimeTypes[$ext]
      if (-not $contentType) { $contentType = "application/octet-stream" }

      $bytes = [System.IO.File]::ReadAllBytes($filePath)
      $response.ContentType = $contentType
      $response.ContentLength64 = $bytes.Length
      $response.StatusCode = 200
      $response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $indexPath = Join-Path $root "index.html"
      if (Test-Path $indexPath -PathType Leaf) {
        $bytes = [System.IO.File]::ReadAllBytes($indexPath)
        $response.ContentType = "text/html; charset=utf-8"
        $response.ContentLength64 = $bytes.Length
        $response.StatusCode = 200
        $response.OutputStream.Write($bytes, 0, $bytes.Length)
      } else {
        $response.StatusCode = 404
        $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
        $response.OutputStream.Write($msg, 0, $msg.Length)
      }
    }
    $response.OutputStream.Close()
  } catch {
  }
}
