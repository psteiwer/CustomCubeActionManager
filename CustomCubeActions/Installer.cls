Class CustomCubeActions.Installer
{
ClassMethod RunInstaller(pRootDir) As %Status
{
	Set tSC=$$$OK
	
	If $get(pRootDir)'="" {
		Do $system.OBJ.LoadDir(pRootDir_"/CustomCubeActions","ck",,1)
		Set tSC=..ImportImage(pRootDir_"/Assets/CustomCubeActionsManager_Cover.jpg")
		If $$$ISERR(tSC) Quit tSC
	}
	
	Set tItem=##class(%DeepSee.UserLibrary.Link).%New()
	Set tItem.fullName="Custom Cube Actions Manager"
	Set tPage="CustomCubeActions.UI.ActionClassManager.zen"
	Set tItem.href=$system.CSP.GetPortalApp($namespace,tPage) _ tPage
	Set tItem.title="Custom Cube Actions Manager"
	Set tItem.bookCover="{background: {style:'background:white;',src:'covers/CustomCubeActionsManager_Cover.jpg',imageStyle:'width:134px;height:190px;'},header: {text:'$type',style:'display: none;'},title: {text:'$title',style:'top:9.375px;'},image: {style:'display: none;',src:'deepsee/ds2_globe_44.png',imageStyle:'width:64px;height:64px;'},subtitle: {text:'"_##class(CustomCubeActions.Utils).GetVersion()_"',style:'font-size:9px;top:179px;'},footer: {text:'$owner',style:'display: none;'}}"
	Set tSC=tItem.%Save()
	
	Quit tSC
}

/// Import Cover image, code taken from %DeepSee.UI.Dialog.ImageUpload:%OnSubmit
ClassMethod ImportImage(pDir) As %Status
{
	Set tSC=$$$OK
	Set tStream=##class(%Stream.FileBinary).%New()
	Set tSC=tStream.LinkToFile(pDir)
	If $$$ISERR(tSC) Quit tSC
	Set tName="CustomCubeActionsManager_Cover.jpg"

	If $IsObject(tStream)&&(tName'="") {
		Set tFileName=##class(%File).NormalizeDirectory(tName,##class(%DeepSee.UI.Dialog.ImageUpload).%GetImageDirectory())
		Set tLocalFile=##class(%File).%New(tFileName)
		Set tSC = tLocalFile.Open("WUNK\RAW\")
		If $$$ISERR(tSC) Quit
		
		Set tSC=tLocalFile.CopyFrom(tStream)
		If $$$ISERR(tSC) Quit

		Do tLocalFile.Close()
	}
	
	Quit tSC
}
}