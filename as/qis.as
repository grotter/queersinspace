stop();

pLoadFader.removeMovieClip();
customCursor._alpha = 100;

#include "as/zmcTween.as"


//////////////////////////////////////////////////
/*
RANDOMLY SELECT THE FIRST PROJECT WINDOW FROM A PREDEFINED SET
*/
//////////////////////////////////////////////////

firstProjectWindowArray = new Array(winProjectMuseum2, winProjectBlue, winProjectDonut);
q = Math.ceil(Math.random() * firstProjectWindowArray.length) - 1;
_global.firstProjectWindow = firstProjectWindowArray[q];
//trace(_global.firstProjectWindow);


//////////////////////////////////////////////////
/*
TOP RIGHT CLIP CODE
*/
//////////////////////////////////////////////////

_global.populateTopRightTextField = function(path) {
	path.versionText.text = getVersion() + " [$swfSize = " + Math.round(_root.swfSize / 1024) + "k]";
	path.versionText.autoSize = "right";
	path.versionBg._width = path.versionText._width - 6;
};


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
FIND AND DELETE AN ARRAY ELEMENT
*/
//////////////////////////////////////////////////

function findAndDeleteFromArray(myArray, whatToDelete) {
	for(var i = 0; i < myArray.length; i++) {
		if(myArray[i] == whatToDelete) myArray.splice(i, 1);
	};
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
	if (!win.minimized) {
		return (Stage.height - (win.realHeight / 2)) - (win._parent.menuMC._height + 20);
	} else {
		return (Stage.height + ((win.realHeight / 2) - 43) - (win._parent.menuMC._height + 20));
	};
};
function calculateMinY(win) {
	return win.realHeight / 2;
};
function calculateMaxX(win) {
	return Stage.width - (win.realWidth / 2) - 14;
};
function calculateMinX(win) {
	return (win.realWidth / 2) + 13;
};
function randomlyPositionWindow(win) {
	_global.disableButtons = true;
	
	winX = Math.random() * (calculateMaxX(win) - calculateMinX(win)) + calculateMinX(win);
	winY = Math.random() * (calculateMaxY(win) - calculateMinY(win)) + calculateMinY(win);
	
	win.tween("_x", winX, .8);
	win.tween("_y", winY, 1.2, "easeOutExpo", 0, function() { _global.disableButtons = false; });
};
function randomlyPositionFirstWindows(win) {
	_global.disableButtons = true;
	
	win._visible = true;
	
	if (win._name.substr(3, 7) == "Project") {
		win.content.corners.play();
	};
	
	winX = Math.random() * (calculateMaxX(win) - calculateMinX(win)) + calculateMinX(win);
	winY = Math.random() * (calculateMaxY(win) - calculateMinY(win)) + calculateMinY(win);
	
	win.tween("_x", winX, .8);
	win.tween("_y", winY, 1.2, "easeOutExpo", 0, function() { _global.disableButtons = false; });
	
	//LOAD PICS IF WE'RE BRINGING IN A PROJECT WINDOW
	if (win._name.substr(3, 7) == "Project") {
		win.stripString = "winProject".length;
		win.projectDirectory = (win._name.substr(win.stripString)).toLowerCase();
		clearInterval(win.content.picHolder.p);
		_global.pauser(win.content.picHolder, .8, function() {
			loadMovie("projects/" + win.projectDirectory + "/pics.swf", win.content.picHolder);
		})
	};
};

function elementsInitialPosition() {
	topRight._x = Stage.width - 10;
	topRight._y = 7;
	menuMC._x = 11;
	menuMC._y = Stage.height - 6;
	topRight._alpha = 0;
	menuMC._alpha = 0;
	topRight._visible = true;
	menuMC._visible = true;
};

function topLeftPosition(win) {
	win._x = -win.transBackground._width;
	win._y = -win.transBackground._height;
};
function animateFirstWindows() {
	_global.firstProjectWindow._visible = true;
	winNews._visible = true;
	
	randomlyPositionFirstWindows(winNews);
	randomlyPositionFirstWindows(_global.firstProjectWindow);
	_global.eventSound();
};
function introAnimation() {
	menuMC.tween("_alpha", 100, 1);
	topRight.tween("_alpha", 100, 1, "easeOutExpo", 0, animateFirstWindows);
};

function positionElements() {
	_global.eventSound();
	topRight.tween("_x", Stage.width - 10, .6);
	menuMC.tween("_y", Stage.height - 6, .6);
	
	//RANDOMLY POSITION WINDOWS CURRENTLY ON THE STAGE
	for(var i = 0; i < _global.windowsOnStageArray.length; i++) {
		randomlyPositionWindow(_global.windowsOnStageArray[i]);
	};
};

function onResize() {
	if (!this.$resizeIntervalID) {
		this.$resizeIntervalID = setInterval(this, "$onResize", 600);
	};
};
this.$onResize = function() {
	positionElements();
	mainBgButton._width = Stage.width;
	mainBgButton._height = Stage.height;
	clearInterval(this.$resizeIntervalID);
	delete(this.$resizeIntervalID);
};


//////////////////////////////////////////////////
/*
WINDOW FOCUS/BLUR CODE
*/
//////////////////////////////////////////////////

qisDepth = 1;
function killWinFocus(killMC, liveMC) {
	qisDepth++;
	_global.okToKillFocus = false;
	clearInterval(killMC.p);
	_global.pauser(killMC, .6, function() { _global.okToKillFocus = true; });
	
	customCursor.swapDepths(qisDepth + 5);
	menuMC.swapDepths(qisDepth + 4);
	topRight.swapDepths(qisDepth + 3)
	liveMC.swapDepths(qisDepth + 2);
	killMC.swapDepths(qisDepth + 1);	
	
	killMC.focused = false;
	liveMC.focused = true;
	
	if(killMC._name == "winContact") {
		killMC.content.contactMC.name.tabEnabled = false;
		killMC.content.contactMC.email.tabEnabled = false;
		killMC.content.contactMC.message.tabEnabled = false;
	};
	if(liveMC._name == "winContact") {
		liveMC.content.contactMC.name.tabEnabled = true;
		liveMC.content.contactMC.email.tabEnabled = true;
		liveMC.content.contactMC.message.tabEnabled = true;
	};
	
	if(killMC._name.substr(0, 10) == "winProject") {
		killMC.content.commentsMC.name.tabEnabled = false;
		killMC.content.commentsMC.email.tabEnabled = false;
		killMC.content.commentsMC.comment.tabEnabled = false;
	};
	if(liveMC._name.substr(0, 10) == "winProject") {
		liveMC.content.commentsMC.name.tabEnabled = true;
		liveMC.content.commentsMC.email.tabEnabled = true;
		liveMC.content.commentsMC.comment.tabEnabled = true;
	};
	
	liveMC.screen._visible = false;
	liveMC.startDrag(false, -liveMC.realWidth, calculateMinY(liveMC), (Stage.width + liveMC.realWidth), calculateMaxY(liveMC));
	liveMC.onRelease = function() {
		liveMC.stopDrag();
		delete this.onPress;
		delete this.onRelease;
	};
	
	delete liveMC.onPress;
	findAndDeleteFromArray(_global.windowsOnStageArray, liveMC);
	_global.windowsOnStageArray.unshift(liveMC);
	killMC.onPress = function() {
		if (_global.okToKillFocus) {
			killWinFocus(_global.windowsOnStageArray[0], this);
		};
	};
	
	killMC.screen._alpha = 0;
	killMC.screen._visible = true;
	killMC.screen.alphaTo(100, .6);
};


//////////////////////////////////////////////////
/*
DOUBLE CLICK PROTOTYPE
*/
//////////////////////////////////////////////////

_global.doubleClickSpeed = 400;
MovieClip.prototype.addProperty("onDoubleClick", function() {
     return this.$onDoubleClick;
     }, function(f) {
     this.__proto__ = DoubleClick.prototype;
     this.$onDoubleClick = f;
     ASSetPropFlags(this,["$onDoubleClick"], 1, true);
});
DoubleClick = function() {};
DoubleClick.prototype = new MovieClip();
DoubleClick.prototype.onMouseDown = function() {
	if(this.hitTest(_root._xmouse,_root._ymouse,true)) {
		if((this.t = getTimer()) < this.$a + _global.doubleClickSpeed) {
			this.$a = this.t = -_global.doubleClickSpeed;
			this.$onDoubleClick()
		} else {
			this.$a = this.t;
		};
	};
};
ASSetPropFlags(MovieClip.prototype,["onDoubleClick"], 7, true);
ASSetPropFlags(this,["DoubleClick"], 7, true);


//////////////////////////////////////////////////
/*
POPUP WINDOW FUNCTION
*/
//////////////////////////////////////////////////

_global.popWin = function(URL, width, height, scroll) {
	//trace(URL);
	getURL("Javascript:popWin('" + URL + "','" + width + "','" + height + "','" + scroll + "');");
};


//////////////////////////////////////////////////
/*
GREG'S AWESOME EASING SCROLLER
*/
//////////////////////////////////////////////////

_global.easingScroller = function(path, textContent, scrollSpeed, bottomPadding) {	
	path.contentMC.content.autoSize = "left";
	
	path.contentMC.content.html = true;
	path.contentMC.content.htmlText = textContent;
	
	//TURN OFF SCROLLING IF THE TEXT DOESN'T OVERFLOW OUR MASK
	if (path.contentMC.content._height < path.contentMask._height) path.scrollHandle._visible = false;
	
	path.handleInitialPosition = path.scrollHandle._y;
	path.scrollAnimate = true;
	
	path.totalHeight = path.contentMask._height - path.scrollHandle._height;
	path.offSet = path.contentMC._height - (path.contentMask._height - bottomPadding);
	
	function scrollAnimator() {
		//trace("scrollAnimator() called.");
		path.scrollPercent = (path.scrollHandle._y - path.handleInitialPosition) / path.totalHeight;
		path.targety = -(path.scrollPercent * path.offSet);
		path.contentMC._y += (path.targety - path.contentMC._y) / scrollSpeed;
		if((path.targety - path.contentMC._y) < 1 && (path.targety - path.contentMC._y) > -1 && !path.scrollAnimate) {
			delete path.contentMC.onEnterFrame;
		};
	};
	
	path.scrollHandle.onPress = function() {
		if (!_global.disableButtons) {
			startDrag(this, false, this._x, this._parent.handleInitialPosition, this._x, (this._parent.contentMask._height + this._parent.contentMask._y) - (this._height / 2));
			this._parent.scrollAnimate = true;
			this._parent.contentMC.onEnterFrame = scrollAnimator;
		};
	};
	path.scrollHandle.onRelease = function() {
		if (!_global.disableButtons) {
			stopDrag();
			this._parent.scrollAnimate = false;
		};
	};
	path.scrollHandle.onReleaseOutside = path.scrollHandle.onRelease;
};


//////////////////////////////////////////////////
/*
GREG'S AWESOME INCREMENTAL IMAGE SCROLLER
*/
//////////////////////////////////////////////////

_global.picScroller = function(path, totalPics) {
	_global.picWidth = 197;
	
	path.picMask._height = 0;
	path.picMask.tween("_height", 272, .8);
	
	_global.disableButtons = false;
	path.currentPic = 1;
	path.pic1._x = path.picMask._x;
	
	path._parent.leftArrow.onRelease = function() {
		if (path._parent._parent.focused) {
			if (this._parent.picHolder.currentPic > 1) {
				this._parent.picHolder["pic" + (this._parent.picHolder.currentPic - 1)].swapDepths(this._parent.picHolder["pic" + this._parent.picHolder.currentPic]);
				
				this._parent.picHolder["pic" + (this._parent.picHolder.currentPic - 1)]._x = this._parent.picHolder.picMask._x - _global.picWidth;
				this._parent.picHolder["pic" + (this._parent.picHolder.currentPic - 1)].tween("_x", this._parent.picHolder.picMask._x, .6);
				this._parent.picHolder["pic" + this._parent.picHolder.currentPic].tween("_x", (this._parent.picHolder.picMask._x + _global.picWidth), .8);
				this._parent.picHolder.currentPic--;
			} else if (this._parent.picHolder.currentPic == 1) {
				this._parent.picHolder["pic" + totalPics].swapDepths(this._parent.picHolder["pic" + this._parent.picHolder.currentPic]);
				
				this._parent.picHolder["pic" + totalPics]._x = this._parent.picHolder.picMask._x - _global.picWidth;
				this._parent.picHolder["pic" + totalPics].tween("_x", this._parent.picHolder.picMask._x, .6);
				this._parent.picHolder["pic" + this._parent.picHolder.currentPic].tween("_x", (this._parent.picHolder.picMask._x + _global.picWidth), .8);
				this._parent.picHolder.currentPic = totalPics;
			};
		};
	};
	
	path._parent.rightArrow.onRelease = function() {
		if (path._parent._parent.focused) {
			if (this._parent.picHolder.currentPic < totalPics) {
				this._parent.picHolder["pic" + (this._parent.picHolder.currentPic + 1)]._x = this._parent.picHolder.picMask._x + _global.picWidth;
				this._parent.picHolder["pic" + this._parent.picHolder.currentPic].tween("_x", (this._parent.picHolder.picMask._x - _global.picWidth), .8);
				this._parent.picHolder["pic" + (this._parent.picHolder.currentPic + 1)].tween("_x", this._parent.picHolder.picMask._x, .6);
				this._parent.picHolder.currentPic++;
			} else if (this._parent.picHolder.currentPic == totalPics) {
				this._parent.picHolder.pic1._x = this._parent.picHolder.picMask._x + _global.picWidth;
				this._parent.picHolder.pic1.swapDepths(this._parent.picHolder["pic" + this._parent.picHolder.currentPic]);
				this._parent.picHolder["pic" + this._parent.picHolder.currentPic].tween("_x", (this._parent.picHolder.picMask._x - _global.picWidth), .8);
				this._parent.picHolder.pic1.tween("_x", this._parent.picHolder.picMask._x, .6);
				this._parent.picHolder.currentPic = 1;
			};
		};
	};
	
	path._parent.bigButton.onRelease = path._parent.rightArrow.onRelease;
};


//////////////////////////////////////////////////
/*
MAXIMIZE AND MINIMIZE WINDOW
*/
//////////////////////////////////////////////////

_global.windowState = function(path) {
	_global.disableButtons = true;
	if(!path.minimized) {
		path.expandedHeight = path.transBackground._height;
		path.minimized = true;
		path.content._visible = false;
		path.transBackground.tween("_height", 23, .4, "easeOutExpo", 0, function() { _global.disableButtons = false; });
		path.screen.tween("_height", 24, .4);
	} else {
		path.minimized = false;
		clearInterval(path.p);
		_global.pauser(path, .4, function() { path.content._visible = true; });
		path.screen.tween("_height", path.expandedHeight + 1, .4);
		if (path._y >= calculateMaxY(path)) {
			path.transBackground.tween("_height", path.expandedHeight, .5);
			path.tween("_y", calculateMaxY(path), .6, "easeOutExpo", 0, function() { _global.disableButtons = false; });
		} else {
			path.transBackground.tween("_height", path.expandedHeight, .5, "easeOutExpo", 0, function() { _global.disableButtons = false; });
		};
	};
};


//////////////////////////////////////////////////
/*
ASSIGN WINDOW TOP BAR BUTTON FUNCTIONS
*/
//////////////////////////////////////////////////

_global.activateWindowButtons = function(path) {
	path.screen._visible = false;
	
	path.dragBar.onPress = function() {
		if(!_global.disableButtons && path.focused) this._parent.startDrag(false, -this._parent.realWidth, calculateMinY(this._parent), (Stage.width + this._parent.realWidth), calculateMaxY(this._parent));
	};
	path.dragBar.onRelease = function() {
		if(!_global.disableButtons && path.focused) this._parent.stopDrag();
	};
	path.dragBar.onReleaseOutside = path.dragBar.onRelease;
	path.dragBar.onDoubleClick = function() {
		if(!_global.disableButtons && path.focused) _global.windowState(path);
	};
	path.minimizeButton.onPress = path.dragBar.onDoubleClick;
	
	path.closeButton.onRelease = function() {
		if(!_global.disableButtons && path.focused) {
			topLeftPosition(this._parent);
			
			//FOCUS THE WINDOW UNDER THE CLOSED WINDOW
			if(_global.windowsOnStageArray.length >= 2) {
				_global.windowsOnStageArray[1].screen.alphaTo(0, .6);
				_global.windowsOnStageArray[1].focused = true;
				delete _global.windowsOnStageArray[1].onPress;
				delete _global.windowsOnStageArray[1].onRelease;
				
				if(_global.windowsOnStageArray[1]._name == "winContact") {
					_global.windowsOnStageArray[1].content.contactMC.name.tabEnabled = true;
					_global.windowsOnStageArray[1].content.contactMC.email.tabEnabled = true;
					_global.windowsOnStageArray[1].content.contactMC.message.tabEnabled = true;
				};
				if(_global.windowsOnStageArray[1]._name.substr(0, 10) == "winProject") {
					_global.windowsOnStageArray[1].content.commentsMC.name.tabEnabled = true;
					_global.windowsOnStageArray[1].content.commentsMC.email.tabEnabled = true;
					_global.windowsOnStageArray[1].content.commentsMC.comment.tabEnabled = true;
				};
			};
			
			if(this._parent.minimized) {
				this._parent.minimized = false;
				this._parent.content._visible = true;
				this._parent.screen._height = this._parent.realHeight + 1;
				this._parent.transBackground._height = this._parent.realHeight - 20;
			};
			
			findAndDeleteFromArray(_global.windowsOnStageArray, this._parent);
			this._parent._visible = false;
			
			if(this._parent._name.substr(3, 7) == "Project") {
				this._parent.content.myName = "";
				this._parent.content.myEmail = "";
				this._parent.content.myComment = "";
				
				this._parent.content.gotoAndStop(1);
				
				this._parent.content.corners.gotoAndStop(1);
				unloadMovie(this._parent.content.picHolder);
				this._parent.picsLoaded = false;
			};
			
			if(this._parent._name == "winContact") {
				this._parent.content.contactMC.name.text = "";
				this._parent.content.contactMC.email.text = "";
				this._parent.content.contactMC.message.text = "";
			};
		};
	};
};


//////////////////////////////////////////////////
/*
ASSIGN COMMENTS BUTTONS
*/
//////////////////////////////////////////////////

_global.activateCommentsButtons = function(path) {
	path.content.commentsButton.onRollOver = function() {
		if(path.focused) {
			this._parent.commentsBackground.stopTween();
			//this._parent.descriptionArrow.stopTween();
			this._parent.commentsBackground._alpha = 100;
			//this._parent.descriptionArrow._alpha = 100;
		};
	};
	path.content.commentsButton.onRollOut = function() {
		if(path.focused) {
			this._parent.commentsBackground.alphaTo(15, .6);
			//this._parent.descriptionArrow.alphaTo(15, .6);
		};
	};
	path.content.commentsButton.onRelease = function() {
		if(path.focused) {
			this._parent.commentsBackground._alpha = 15;
			//this._parent.descriptionArrow._alpha = 15;
			this._parent.play();
		};
	};
};


//////////////////////////////////////////////////
/*
SUBMIT COMMENT FORM CODE
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

//CHECK FOR PROPERLY FORMATTED EMAIL ADDRESS INPUT
//INPUT FIELD SHOULD BE SINGLE LINE WITH HTML RENDERING OFF
String.prototype.isEmail = function() {
    var ref = arguments.callee;
    if(this.indexOf("@") == -1) return false;
    if(!isNaN(this.charAt(0))) return false;
    var email, user, domain, user_dots, domain_dots;
    if((email = this.split("@")).length == 2) {
        if((domain = email[1]).split(".").pop().length > 3) return false;
        if((user = email[0]).indexOf(".") && domain.indexOf(".")) {
            if(domain.lastIndexOf(".") > domain.length-3) return false;
            for(var c, t, i = (user_dots = user.split(".")).length; i--;) {
                c = user_dots[i]; t = !ref.$_text.call(c, "-", ".", "_");
                if(t || !isNaN(c)) return false;
            };
            for(var c, t, i = (domain_dots = domain.split(".")).length; i--;) {
                c = domain_dots[i]; t = !ref.$_text.call(c, "-", ".");
                if(t || !isNaN(c)) return false;
            };
        } else return false;
    } else return false;
    return true;
};
String.prototype.isEmail.$_punctuation = function() {
    if(this == "") return false;
    for(var i = arguments.length; i--;) {
        if(this.indexOf(arguments[i]) == 0) return false;
        if(this.indexOf(arguments[i]) == this.length-1) return false;
    };
    return true;
};
String.prototype.isEmail.$_text = function() {
    var ref = arguments.caller;
    if(!ref.$_punctuation.apply(this, arguments)) return false;
    var others = arguments; var checkOthers = function(str) {
        for(var i = others.length; i--;) if(str == others[i]) return true;
        return false;
    };
    for(var c, alpha, num, i = this.length; i--;) {
        c = this.charAt(i).toLowerCase();
        alpha = (c <= "z") && (c >= "a");
        num = (c <= "9") && (c >= "0");
        if(!alpha && !num && !checkOthers(c)) return false;
    };
    return true;
};
ASSetPropFlags(String.prototype, "isEmail", 1);

_global.submitCommentForm = function(path) {
	path.name.tabIndex = 1;
	path.email.tabIndex = 2;
	path.comment.tabIndex = 3;
	
	path.name.text = path._parent.myName;
	path.email.text = path._parent.myEmail;
	path.comment.text = path._parent.myComment;
	
	path.submitButton.onRollOver = function() {
		if(path._parent._parent.focused) {
			this._parent.submitButtonBackground.stopTween();
			this._parent.submitButtonBackground._alpha = 100;
		};
	};
	path.submitButton.onRollOut = function() {
		if(path._parent._parent.focused) this._parent.submitButtonBackground.alphaTo(15, .6);
	};
	path.readCommentsButton.onRollOver = function() {
		if(path._parent._parent.focused) {
			this._parent.readCommentsBackground.stopTween();
			this._parent.readCommentsBackground._alpha = 100;
		};
	};
	path.readCommentsButton.onRollOut = function() {
		if(path._parent._parent.focused) this._parent.readCommentsBackground.alphaTo(15, .6);
	};
	path.readCommentsButton.onRelease = function() {
		if(path._parent._parent.focused) {
			this._parent._parent.myName = this._parent.name.text;
			this._parent._parent.myEmail = this._parent.email.text;
			this._parent._parent.myComment = this._parent.comment.text;
			
			this._parent.play();
		};
	};
	
	path.submitButton.onRelease = function() {
		if(path._parent._parent.focused) {
			this.nameOk = false;
			this.emailOk = false;
			this.commentOk = false;
			
			if (this._parent.name.text == "" || this._parent.name.text == "Please include your name." || this._parent.name.text == "Thank") {
				this._parent.name.text = "Please include your name.";
			} else {
				this.nameVariable = this._parent.name.text;
				this.nameOk = true;
			};
			
			if (this._parent.email.text.isEmail() || this._parent.email.text == "") {
				if (this._parent.email.text == "") {
					this.emailVariable = "NA";
				} else {
					this.emailVariable = this._parent.email.text;
				};
				this.emailOk = true;
			} else {
				this._parent.email.text = "Invalid email address";
			};
			
			if (this._parent.comment.text == "" || this._parent.comment.text == "Please include your comment." || this._parent.comment.text == "Your comment has been posted!") {
				this._parent.comment.text = "Please include your comment."
			} else {
				this.commentVariable = this._parent.comment.text;
				this.commentOk = true;
			};
			
			if (this.nameOk && this.emailOk && this.commentOk) {
				var c = new LoadVars();
				
				c.name = "userComments=_From: " + this.nameVariable.formatComments() + "<br>";
				if (this.emailVariable == "NA") {
					c.email = "Email: " + this.emailVariable + "<br>Posted: "
				} else {
					c.email = "Email: " + "<u><a href='mailto:" + this.emailVariable + "'>" + this.emailVariable + "</a></u><br>Posted: "
				};
				c.comment = "<br>Comment: " + this.commentVariable.formatComments() + "<br><br>";
				
				this.stripString = "winProject".length;
				c.projectDirectory = (path._parent._parent._name.substr(this.stripString)).toLowerCase();
				
				this._parent.name.text = "Thank";
				this._parent.email.text = "You.";
				this._parent.comment.text = "Your comment has been posted!"
				
				c.sendAndLoad("userComments.php", c, "POST");
			};
		};
	};
};


//////////////////////////////////////////////////
/*
READ COMMENTS CODE
*/
//////////////////////////////////////////////////

_global.readComments = function(path) {
	path.commentsScroller._visible = false;
	
	path.stripString = "winProject".length;
	path.projectDirectory = (path._parent._parent._name.substr(path.stripString)).toLowerCase();
	
	var c = new LoadVars();
	c.load("projects/" + path.projectDirectory + "/userComments.txt?nocache=" + Math.round(Math.random() * 1000000000000));
	c.onLoad = function(success) {
		if(success) {
			path.commentsLoader.gotoAndStop(2);
			if(this.userComments == "") this.userComments = "This project currently has no user comments...<br><br>_<br>_"; 
			_global.easingScroller(path.commentsScroller, this.userComments, 6, 0);
			path.commentsScroller._visible = true;
		};
	};
	
	path.submitACommentButton.onRollOver = function() {
		if(path._parent._parent.focused) {
			this._parent.submitACommentBackground.stopTween();
			this._parent.submitACommentBackground._alpha = 100;
		};
	};
	path.submitACommentButton.onRollOut = function() {
		if(path._parent._parent.focused) this._parent.submitACommentBackground.alphaTo(15, .6);
	};
	path.submitACommentButton.onRelease = function() {
		if(path._parent._parent.focused) this._parent.gotoAndStop(1);
	};
};


//////////////////////////////////////////////////
/*
INITIALIZE ALL PROJECTS WINDOW
*/
//////////////////////////////////////////////////

_global.clickReleaseTime = 300;

_global.setupAllProjectsWinButtons = function(path) {
	path.invisButton.onPress = function() {
		if(!_global.disableButtons && path._parent._parent.focused) {
			this.pressTime = getTimer();
			this._parent.startDrag(false, (this._parent._parent.dragConstrainer._x + (this._parent._width / 2) + 4), (this._parent._parent.dragConstrainer._y + (this._parent._height / 2) + 4), (this._parent._parent.dragConstrainer._width - (this._parent._width / 2) - 1), (this._parent._parent.dragConstrainer._height - (this._parent._height / 2) - 2));
		};
	};
	path.invisButton.onRelease = function() {
		if(!_global.disableButtons && path._parent._parent.focused) {
			this.releaseTime = getTimer();
			this._parent.stopDrag();
			this._parent.paper.paperBg.alphaTo(0, 1.5);
			
			if((this.releaseTime - this.pressTime) <= _global.clickReleaseTime) {
				_global.disableButtons = true;
				clearInterval(this.p);
				_global.pauser(this, 1.2, function() { _global.disableButtons = false; });
				winNavigation(eval("win" + this._parent._name.substr(5, this._parent._name.length)));
			};
		};
	};
	path.invisButton.onReleaseOutside = path.invisButton.onRelease;
	
	path.invisButton.onRollOver = function() {
		if(!_global.disableButtons && path._parent._parent.focused) {
			this._parent.paper.paperBg.stopTween();
			this._parent.paper.paperBg._alpha = 15;
		};
	};
	path.invisButton.onRollOut = function() {
		if(!_global.disableButtons && path._parent._parent.focused) {
			this._parent.paper.paperBg.alphaTo(0, 1.5);
		};
	};
};

_global.initializeAllProjectsWin = function(path) {
	//LOOP THROUGH CLIPS IN winAllProjects AND ASSIGN _global.setupAllProjectsWinButtons TO EACH BUTTON
	for(MC in path.content) {
		if (path.content[MC] instanceof MovieClip && path.content[MC]._name.substr(0, 12) == "paperProject") {
			_global.setupAllProjectsWinButtons(path.content[MC]);
		};
	};
};


//////////////////////////////////////////////////
/*
- GET THE REAL DIMENSIONS OF OUR WINDOWS
- PLACE ALL WINDOWS IN TOP LEFT CORNER
- ACTIVATE WINDOW BUTTONS FOR ALL WINDOWS
- ACTIVATE COMMENTS BUTTONS FOR ALL PROJECT WINDOWS
- TURN OFF CORNER BLINK FOR ALL PROJECT WINDOWS
*/
//////////////////////////////////////////////////

for(MC in this) {
	if (this[MC] instanceof MovieClip && this[MC]._name.substr(0, 3) == "win") {
		this[MC].focused = false;
		this[MC].realWidth = this[MC].transBackground._width;
		this[MC].realHeight = this[MC].transBackground._height + 20;
		topLeftPosition(this[MC]);
		_global.activateWindowButtons(this[MC]);
		
		if (this[MC] instanceof MovieClip && this[MC]._name.substr(0, 10) == "winProject") {
			_global.activateCommentsButtons(this[MC]);
			this[MC].content.corners.gotoAndStop(1);
			this[MC].picsLoaded = false;
			//getURL("javascript:alert('" + this[MC].content.corners + "');");
		};
	};
};


//////////////////////////////////////////////////
/*
"TRACE" _global.windowsOnStageArray
*/
//////////////////////////////////////////////////

topRight.onRelease = function() {
	//trace(_global.windowsOnStageArray);
	getURL("javascript:alert('_global.windowsOnStageArray = [" + _global.windowsOnStageArray + "]');");
};


//////////////////////////////////////////////////
/*
EVENT SOUNDS
*/
//////////////////////////////////////////////////

_global.eventSoundVolume = 43;

sound1 = new Sound(winNews);
sound1.attachSound("sound1");
sound1.setVolume(_global.eventSoundVolume);
sound2 = new Sound(winLinks);
sound2.attachSound("sound2");
sound2.setVolume(_global.eventSoundVolume);
sound3 = new Sound(menuMC);
sound3.attachSound("sound3");
sound3.setVolume(_global.eventSoundVolume);
sound4 = new Sound(topRight);
sound4.attachSound("sound4");
sound4.setVolume(_global.eventSoundVolume);
sound5 = new Sound(winContact);
sound5.attachSound("sound5");
sound5.setVolume(_global.eventSoundVolume);
sound6 = new Sound(winAllProjects);
sound6.attachSound("sound6");
sound6.setVolume(_global.eventSoundVolume);

_global.eventSound = function() {
	var diceToss = Math.round(Math.random() * 5 + 1);
	eval("sound" + diceToss).start();
};


//////////////////////////////////////////////////
/*
MAIN NAVIGATION FUNCTION
*/
//////////////////////////////////////////////////

function winNavigation(path) {
	path._visible = true;
	_global.eventSound();
	
	//LOAD PICS IF IT'S A PROJECT WINDOW AND IF IT'S BEEN PREVIOUSLY CLOSED OR NEWLY OPENED 
	if(!path.picsLoaded) {
		if (path._name.substr(3, 7) == "Project") {
			path.content.corners.play();
			path.picsLoaded = true;
			
			clearInterval(path.content.picHolder.p);
			_global.pauser(path.content.picHolder, 1, function() {
				path.stripString = "winProject".length;
				path.projectDirectory = (path._name.substr(path.stripString)).toLowerCase();
				loadMovie("projects/" + path.projectDirectory + "/pics.swf", path.content.picHolder);
			});
		};
	};
	
	//IF THE WINDOW IS MINIMIZED, MAXIMIZE IT
	if(path.minimized) {
		path.minimized = false;
		clearInterval(path.content.p);
		_global.pauser(path.content, .4, function() { path.content._visible = true; });
		path.transBackground.tween("_height", path.expandedHeight, .5, "easeOutExpo", 0, function() { _global.disableButtons = false; });
		path.screen.tween("_height", path.expandedHeight + 1, .4);
	};
	
	//IF WINDOW ISN'T ALREADY FOCUSED, FOCUS AND RANDOMLY POSITION IT; OTHERWISE, JUST RANDOMLY POSITION IT
	if(_global.windowsOnStageArray[0] != path) {
		findAndDeleteFromArray(_global.windowsOnStageArray, path);
		killWinFocus(_global.windowsOnStageArray[0], path);
		delete path.onRelease;
		path.stopDrag();
		randomlyPositionWindow(path);
	} else {
		randomlyPositionWindow(path);
	};
	
};

//THIS IS A SPECIAL FUNCTION FOR A HYPERLINK IN qisNews.txt
function contactNavigation() {
	winNavigation(winContact);
};


//////////////////////////////////////////////////
/*
MAIN BACKGROUND BUTTON CODE
*/
//////////////////////////////////////////////////

mainBgButton._width = Stage.width;
mainBgButton._height = Stage.height;
mainBgButton.onRelease = function() {
	bgClick = true;
	
	for(var i = 0; i < _global.windowsOnStageArray.length; i++) {
		//trace(bgClick);
		if(_global.windowsOnStageArray[i].hitTest(_root._xmouse,_root._ymouse,true) && !_global.windowsOnStageArray[i].minimized) {
			bgClick = false;
		} else if(_global.windowsOnStageArray[i].dragBar.hitTest(_root._xmouse,_root._ymouse,true) || _global.windowsOnStageArray[i].minimizeButton.hitTest(_root._xmouse,_root._ymouse,true) || _global.windowsOnStageArray[i].closeButton.hitTest(_root._xmouse,_root._ymouse,true)) {
			bgClick = false;
		};
	};
	if(this._parent.menuMC.hitTest(_root._xmouse,_root._ymouse,true)) bgClick = false;
	if(this._parent.topRight.hitTest(_root._xmouse,_root._ymouse,true)) bgClick = false;
	if(_global.windowsOnStageArray.length == 0) bgClick = false;
	
	if(bgClick) positionElements();
};


//////////////////////////////////////////////////
/*
CONTACT FORM CODE
*/
//////////////////////////////////////////////////

_global.contactForm = function(path) {
	path.content.contactMC.name.tabIndex = 4;
	path.content.contactMC.email.tabIndex = 5;
	path.content.contactMC.message.tabIndex = 6;
	
	path.content.contactMC.name.tabEnabled = false;
	path.content.contactMC.email.tabEnabled = false;
	path.content.contactMC.message.tabEnabled = false;
	
	path.content.contactMC.submitButton.onRollOver = function() {
		if (path.focused) {
			this._parent.submitBackground.stopTween();
			this._parent.submitBackground._alpha = 100;
		};
	};
	path.content.contactMC.submitButton.onRollOut = function() {
		if (path.focused) this._parent.submitBackground.alphaTo(15, .6);
	};
	path.content.contactMC.clearButton.onRollOver = function() {
		if (path.focused) {
			this._parent.clearBackground.stopTween();
			this._parent.clearBackground._alpha = 100;
		};
	};
	path.content.contactMC.clearButton.onRollOut = function() {
		if (path.focused) this._parent.clearBackground.alphaTo(15, .6);
	};
	
	path.content.contactMC.clearButton.onRelease = function() {
		if (path.focused) {
			this._parent.name.text = "";
			this._parent.email.text = "";
			this._parent.message.text = "";
		};
	};
	
	path.content.contactMC.submitButton.onRelease = function() {
		if (path.focused) {
			this.nameOk = false;
			this.emailOk = false;
			this.messageOk = false;
			
			if (this._parent.name.text == "" || this._parent.name.text == "Please include your name." || this._parent.name.text == "Thank") {
				this._parent.name.text = "Please include your name.";
			} else {
				this.nameOk = true;
			};
			
			if (this._parent.email.text.isEmail()) {
				this.emailOk = true;
			} else if (this._parent.email.text == "" || this._parent.email.text == "Please include your email address." || this._parent.email.text == "You.") {
				this._parent.email.text = "Please include your email address.";
			} else {
				this._parent.email.text = "Invalid email address";
			};
			
			if (this._parent.message.text == "" || this._parent.message.text == "Please include a message." || this._parent.message.text == "Your message has been sent!") {
				this._parent.message.text = "Please include a message."
			} else {
				this.messageOk = true;
			};
			
			if (this.nameOk && this.emailOk && this.messageOk) {
				var m = new LoadVars();
				
				m.name = this._parent.name.text;
				m.email = this._parent.email.text;
				m.message = this._parent.message.text;
				
				m.sendAndLoad("qisContact.php", m, "POST");
				
				this._parent.name.text = "Thank";
				this._parent.email.text = "You.";
				this._parent.message.text = "Your message has been sent!"
			};
		};
	};
};


//////////////////////////////////////////////////
/*
SETUP THE MENU BUTTONS
*/
//////////////////////////////////////////////////

_global.assignMenuRollOvers = function(j) {
	menuMC["menuButton" + j].onRollOver = function() {
		this._parent["menuBg" + j].stopTween();
		this._parent["menuBg" + j]._alpha = 100;
	};
	menuMC["menuButton" + j].onRollOut = function() {
		this._parent["menuBg" + j].alphaTo(15, .6);
	};
};
for(var k = 1; k < 6; k++) {
	_global.assignMenuRollOvers(k);
};

menuMC.menuButton1.onRelease = function() {
	winNavigation(this._parent._parent.winAllProjects);
};
menuMC.menuButton2.onRelease = function() {
	winNavigation(this._parent._parent.winNews);
};
menuMC.menuButton3.onRelease = function() {
	winNavigation(this._parent._parent.winLinks);
};
menuMC.menuButton4.onRelease = function() {
	winNavigation(this._parent._parent.winMissionStatement);
};
menuMC.menuButton5.onRelease = function() {
	winNavigation(this._parent._parent.winContact);
};


//////////////////////////////////////////////////
/*
SET SOME STUFF UP
*/
//////////////////////////////////////////////////

_global.windowsOnStageArray = new Array();

//REQUIRED FOR INITIAL ELEMENTS/WINDOWS
topRight._visible = false;
menuMC._visible = false;
_global.firstProjectWindow._visible = false;
winNews._visible = false;
_global.windowsOnStageArray.unshift(winNews);
_global.windowsOnStageArray.unshift(_global.firstProjectWindow);
_global.firstProjectWindow.picsLoaded = true;
_global.firstProjectWindow.focused = true;

winNews.screen._visible = true;
winNews.onPress = function() {
	killWinFocus(_global.windowsOnStageArray[0], this);
};

//MISC FUNCTION CALLS, ETC.
_global.disableButtons = true;
_global.populateTopRightTextField(topRight);
_global.initializeAllProjectsWin(winAllProjects);
_global.contactForm(winContact);
fadeDotDown();
elementsInitialPosition();
introAnimation();