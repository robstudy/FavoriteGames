<h1>Favorite Video Games - iOS App</h1>

Application contains a list of the users favorite video games, with data provided by the GiantBomb.com api.

When the app starts the user will be presented with a TabBarController containing a TableViewController and a CollectionViewController. If the user has previously added games from the search option the user will first be presented with a list, which will have the game art and the game name displayed. Alternatively the user can choose to only view the collection view, which will only display the games thumbnail art.

If no games have been added the user can press the "+" button at the top right corner. The user will be presented with a new view controller which can be used to type in a game name. Once a game name is chosen the user will have to press the search button to get information from the API, and an alert view will appear until data is retrieved. Once the data is returned a list of up to 15 games will appear in a table view for the user to select. Once the user selects a game the search view controller will be dismissed and the user will be popped back into the last view controller (either list or collection) and the game will now be displayed in the games list and saved.

The user can click on the game from either collection or list view and a new view will display the games details. The detail view displays the games art, description of the game, and its name. There is also a button in each detail view with the instructions - “Go to GiantBomb For More!”. If clicked the user will directed to giantbomb.com web page for the game.

If the user wishes to delete a game from the list it can be done in either the detail view of the game (a delete button is located at the top right corner), or the user can swipe the table cell from the list view and delete the cell and game from the list. If the user deletes the game from the detail view, the view will be immediately dismissed and the game will have disappeared from the games list.


<h2>How to Run</h2>

In order to run the app the user will need a Mac and X-Code. Open the xcodeproj file in Xcode. In Xcode go to Product > Run, or press the Run button at the top left hand side of the opened project. Run project on simulator for either iPad or iPhone.