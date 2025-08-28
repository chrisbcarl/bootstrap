Allow Connectivity During connected-standby (on battery / pugged in ) disable
https://www.tenforums.com/tutorials/146593-enable-disable-network-connectivity-modern-standby-windows-10-a.html
GPO > Computer Configuration > Administrative Templates > System > Power Management > Sleep Settings
powercfg /batteryreport
Battery life report saved to file path C:\WINDOWS\system32\battery-report.html.

C:\WINDOWS\system32>powercfg /sleepstudy
Sleep Study report saved to file path C:\WINDOWS\system32\sleepstudy-report.html.