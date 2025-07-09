stop();

#include "../as/zmcTween.as"

//////////////////////////////////////////////////
/*
GREG'S AWESOME MX PAUSER
*/
//////////////////////////////////////////////////

_global.pauser = function(mcName, secondsToPause, endFunction) {
	mcName.p++;
	function donePausing() {
		clearInterval(mcName.p);
		if (endFunction == undefined) {
			mcName.play();
		} else {
			endFunction();
		};
	};
	if (endFunction == undefined) {
		mcName.stop();
	};
	mcName.p = setInterval(donePausing, secondsToPause*1000);
};

//////////////////////////////////////////////////
/*
FADE THE CURSOR DOT
*/
//////////////////////////////////////////////////

function fadeDotDown() {
	customCursor.cursorDot.tween("_alpha", 0, .6, "easeOutExpo", 0, fadeDotUp);
};
function fadeDotUp() {
	customCursor.cursorDot.tween("_alpha", 100, .6, "easeOutExpo", 0, fadeDotDown);
};


//////////////////////////////////////////////////
/*
WINDOW ANIMATION CODE
*/
//////////////////////////////////////////////////

function calculateMaxY(win) {
	return (Stage.height - (win.realHeight / 2)) - 10;
};
function calculateMinY(win) {
	return (win.realHeight / 2) + 10;
};
function calculateMaxX(win) {
	return (Stage.width - (win.realWidth / 2)) - 10;
};
function calculateMinX(win) {
	return (win.realWidth / 2) + 10;
};
function randomlyPositionWindow(win) {
	winX = Math.random() * (calculateMaxX(win) - calculateMinX(win)) + calculateMinX(win);
	winY = Math.random() * (calculateMaxY(win) - calculateMinY(win)) + calculateMinY(win);
	
	win.tween("_x", winX, 1);
	win.tween("_y", winY, 1.4);
};

function onResize() {
	if (!this.$resizeIntervalID) {
		this.$resizeIntervalID = setInterval(this, "$onResize", 300);
	};
};
this.$onResize = function() {
	randomlyPositionWindow(winAdmin);
	clearInterval(this.$resizeIntervalID);
	delete(this.$resizeIntervalID);
};


//////////////////////////////////////////////////
/*
ASSIGN WINDOW TOP BAR BUTTON FUNCTIONS
*/
//////////////////////////////////////////////////

_global.activateWindowButtons = function(path) {
	path.dragBar.onPress = function() {
		this._parent.startDrag();
	};
	path.dragBar.onRelease = function() {
		this._parent.stopDrag();
	};
	path.dragBar.onReleaseOutside = path.dragBar.onRelease;
};


//////////////////////////////////////////////////
/*
STRING PROTOTYPES
*/
//////////////////////////////////////////////////

//URL ENCODE SOME STUFF
String.prototype.searchReplace = function(find, replace) {
	return this.split(find).join(replace);
};
String.prototype.formatComments = function() {
	temp = this.searchReplace("%", "%25");
	temp = temp.searchReplace("+", "%2b");
	temp = temp.searchReplace("&", "%26amp;");
	temp = temp.searchReplace("<", "%26lt;");
	temp = temp.searchReplace(">", "%26gt;");
	temp = temp.searchReplace("\"", "%26quot;");
	temp = temp.searchReplace("'", "%26apos;");
	
	return temp;
};


//////////////////////////////////////////////////
/*
ASSIGN NEWS BUTTONS
*/
//////////////////////////////////////////////////

_global.activateAdminButtons = function(path) {
	path.content.newsHeader.tabIndex = 1;
	path.content.newsBody.tabIndex = 2;
	
	path.content.clearButton.onRollOver = function() {
		this._parent.clearBackground.stopTween();
		this._parent.clearBackground._alpha = 100;
	};
	path.content.clearButton.onRollOut = function() {
		this._parent.clearBackground.alphaTo(15, .6);
	};
	path.content.clearButton.onRelease = function() {
		this._parent.clearBackground.alphaTo(15, .4);
		this._parent.newsHeader.text = "";
		this._parent.newsBody.text = "";
	};
	
	path.content.submitButton.onRollOver = function() {
		this._parent.submitBackground.stopTween();
		this._parent.submitBackground._alpha = 100;
	};
	path.content.submitButton.onRollOut = function() {
		this._parent.submitBackground.alphaTo(15, .6);
	};
	path.content.submitButton.onRelease = function() {
		this._parent.submitBackground.alphaTo(15, .4);
		
		this.headerOk = false;
		this.bodyOk = false;
		
		if (this._parent.newsHeader.text == "" || this._parent.newsHeader.text == "Please include a header." || this._parent.newsHeader.text == "Update") {
			this._parent.newsHeader.text = "Please include a header.";
		} else {
			this.headerVariable = this._parent.newsHeader.text;
			this.headerOk = true;
		};
		
		if (this._parent.newsBody.text == "" || this._parent.newsBody.text == "Please include body copy." || this._parent.newsBody.text == "posted!") {
			this._parent.newsBody.text = "Please include body copy."
		} else {
			this.bodyVariable = this._parent.newsBody.text;
			this.bodyOk = true;
		};
		
		if (this.headerOk && this.bodyOk) {
			var c = new LoadVars();
			
			c.newsHeader = "qisNews=**" + (this.headerVariable.formatComments()).toUpperCase() + "<br>Posted: ";
			c.newsBody = "<br>---------------------------------<br>" + this.bodyVariable.formatComments() + "<br><br>";
			
			this._parent.newsHeader.text = "Update";
			this._parent.newsBody.text = "posted!";
			
			c.sendAndLoad("qisNews.php", c, "POST");
		};
	};
};
	
	
winAdmin.realWidth = winAdmin.transBackground._width;
winAdmin.realHeight = winAdmin.transBackground._height + 20;
_global.activateAdminButtons(winAdmin);
_global.activateWindowButtons(winAdmin);
randomlyPositionWindow(winAdmin);
fadeDotDown();
