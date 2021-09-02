# CustomCubeActions
CustomCubeActions allows users to easily manage their custom cube actions within InterSystems Business Intelligence

## Using CustomCubeActions
There are two UI pages to help manage custom cube actions.
1) ActionClassManager provides a UI for assigning action classes to cubes.
2) ActionManager provides a UI for mapping custom actions to cubes.


Navigate to /CustomCubeActions.UI.ActionClassManager.zen to get started. On this page, you can generate an action class for classes that are not currently being managed by CustomCubeActions. If a cube already has an action class defined, the new CustomCubeActions class will contain references to the actions that have already been defined.

After your cubes are configured to be managed by CustomCubeActions, navigate to /CustomCubeActions.UI.ActionManager.zen to begin adding actions. Note that the "Cubes" field can be a comma separated list of cube names, or it can be "All".

## Method Signatures
The methods called by CustomCubeActions require the following signature:
``` ClassMethod MethodName(pAction As %String, pContext As %ZEN.proxyObject) as %Status ```.
This is similar to the [standard custom action signature](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=D2IMP_ch_action#D2IMP_action_defining_behavior). However, CustomCubeActions will typically have one action per method (although this is not required).
