# CustomCubeActionManager
CustomCubeActionManager allows users to easily manage their custom cube actions within InterSystems Business Intelligence

## Using CustomCubeActionManager
To use CustomCubeActionManager, your cube must be able to be modified and compiled. Allowing CustomCubeActionsManager to manage a specific cube's actions requires a modification to your cube definition, which is performed automatically when CustomCubeActionsManager is enabled for a specific cube.

There are two UI pages to help manage custom cube actions.
1) ActionClassManager provides a UI for assigning action classes to cubes.
2) ActionManager provides a UI for mapping custom actions to cubes.


Navigate to the Action Class Manager, which can be found in the User Portal (Management Portal -> Analytics -> User Portal -> Custom Cube Actions Manager) to get started. On this page, you can generate an action class for classes that are not currently being managed by CustomCubeActionManager. If a cube already has an action class defined, the new CustomCubeActions class will automatically generate references to the actions that have already been defined.

After your cubes are configured to be managed by CustomCubeActionManager, navigate to the Action Manager page (Link found on the Action Class Manager page) to begin adding actions. Note that the "Cubes" field can be a comma separated list of cube names, or it can be "All".

## Method Signatures
The methods called by CustomCubeActionManager require the following signature:
``` ClassMethod MethodName(pAction As %String, pContext As %ZEN.proxyObject) as %Status ```.
This is similar to the [standard custom action signature](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=D2IMP_ch_action#D2IMP_action_defining_behavior). However, CustomCubeActionManager will typically have one action per method (although this is not required).
