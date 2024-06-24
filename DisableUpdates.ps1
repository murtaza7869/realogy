# Define the services to be disabled
$services = @(
    "wuauserv",    # Windows Update
    "bits",        # Background Intelligent Transfer Service
    "dosvc",       # Delivery Optimization
    "UsoSvc",      # Update Orchestrator Service
   
)

# Function to disable a service
function Disable-ServiceAndStop {
    param (
        [string]$serviceName
    )

    # Check if the service exists
    if (Get-Service -Name $serviceName -ErrorAction SilentlyContinue) {
        # Stop the service if it is running
        $service = Get-Service -Name $serviceName
        if ($service.Status -eq 'Running') {
            Write-Output "Stopping service: $serviceName"
            Stop-Service -Name $serviceName -Force
        }

        # Disable the service
        Write-Output "Disabling service: $serviceName"
        Set-Service -Name $serviceName -StartupType Disabled
    } else {
        Write-Output "Service $serviceName does not exist on this machine."
    }
}

# Disable and stop each service
foreach ($service in $services) {
    Disable-ServiceAndStop -serviceName $service
}

Write-Output "All specified services have been disabled and stopped."
