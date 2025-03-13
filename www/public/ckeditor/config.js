/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

//CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
//};

CKEDITOR.editorConfig = function( config ) {
  config.docType = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">';
  config.font_defaultLabel = '굴림';
  config.font_names = '굴림/Gulim;돋움/Dotum;바탕/Batang;궁서/Gungsuh;Arial/Arial;Comic Sans MS/Comic Sans MS;Courier New/Courier New;Georgia/Georgia;Lucida Sans Unicode/Lucida Sans Unicode;Tahoma/Tahoma;Times New Roman/Times New Roman;Trebuchet MS/Trebuchet MS;Verdana/Verdana';
  config.fontSize_defaultLabel = '12px';
  config.fontSize_sizes = '8/8px;9/9px;10/10px;11/11px;12/12px;14/14px;16/16px;18/18px;20/20px;22/22px;24/24px;26/26px;28/28px;36/36px;48/48px;';
  config.language = "ko";
  config.resize_enabled = false;
  config.enterMode = 2;
  config.shiftEnterMode = 1;
  config.startupFocus = false;
  config.uiColor = '#eaebe7';
  config.toolbarCanCollapse = false;
  config.toolbarStartupExpanded = false;
  config.menu_subMenuDelay = 0;
  config.htmlEncodeOutput = false;
  config.removePlugins = '';
  config.height = '320px';
  config.toolbar = [
['Undo','Redo'],
['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
['Link','Unlink'],
//['Image','Flash','Table','Smiley','SpecialChar','PageBreak'],
//'/',
['Font','FontSize'],
['TextColor','BGColor']
];
//  config.allowedContent = 'p h1 h2 strong em; a[!href]; img[!src,width,height]';
//  config.extraPlugins = 'doNothing';
//	config.keystrokes = [[ 13 /*Enter*/, 'doNothing']];
};