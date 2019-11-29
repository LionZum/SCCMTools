$build = "1903"
$mfr = "Hewlett-Packard"
$type = "Drivers"
$TSName = "OSD Module Windows 10 Driver Variables 1909"

$ts = Get-CMTaskSequence -Name $TSName
$StepName = 'Set HP Production Driver Package Variables'

$drivers = Get-CMPackage -Name "$type - $mfr * $build *" -fast
ForEach ($driver in $drivers){
    $i1 = $driver.Description.Split(':').Replace(')','')
    $i2 = $i1.get(1)
    $i3 = $i2.Split(',')
    foreach ($object in $i3){
        $hashRule2 = @{'W10X64DRIVERPACKAGE' = $driver.PackageID}
        $rule2 = New-CMTSRule -Variable $hashRule2 -ReferencedVariableName Product -ReferencedVariableOperator equals -ReferencedVariableValue $object
        $ts | Set-CMTaskSequenceStepSetDynamicVariable -StepName $StepName -AddRule $rule2
    }
}
