(function(factory){if(typeof module==="object"&&typeof module.exports!=="undefined"){module.exports=factory}else{factory(FusionCharts)}})(function(FusionCharts){(function(modules){var installedModules={};function __webpack_require__(moduleId){if(installedModules[moduleId]){return installedModules[moduleId].exports}var module=installedModules[moduleId]={i:moduleId,l:false,exports:{}};modules[moduleId].call(module.exports,module,module.exports,__webpack_require__);module.l=true;return module.exports}__webpack_require__.m=modules;__webpack_require__.c=installedModules;__webpack_require__.d=function(exports,name,getter){if(!__webpack_require__.o(exports,name)){Object.defineProperty(exports,name,{configurable:false,enumerable:true,get:getter})}};__webpack_require__.n=function(module){var getter=module&&module.__esModule?function getDefault(){return module["default"]}:function getModuleExports(){return module};__webpack_require__.d(getter,"a",getter);return getter};__webpack_require__.o=function(object,property){return Object.prototype.hasOwnProperty.call(object,property)};__webpack_require__.p="";return __webpack_require__(__webpack_require__.s=21)})({0:function(module,exports){module.exports=function(useSourceMap){var list=[];list.toString=function toString(){return this.map(function(item){var content=cssWithMappingToString(item,useSourceMap);if(item[2]){return"@media "+item[2]+"{"+content+"}"}else{return content}}).join("")};list.i=function(modules,mediaQuery){if(typeof modules==="string")modules=[[null,modules,""]];var alreadyImportedModules={};for(var i=0;i<this.length;i++){var id=this[i][0];if(typeof id==="number")alreadyImportedModules[id]=true}for(i=0;i<modules.length;i++){var item=modules[i];if(typeof item[0]!=="number"||!alreadyImportedModules[item[0]]){if(mediaQuery&&!item[2]){item[2]=mediaQuery}else if(mediaQuery){item[2]="("+item[2]+") and ("+mediaQuery+")"}list.push(item)}}};return list};function cssWithMappingToString(item,useSourceMap){var content=item[1]||"";var cssMapping=item[3];if(!cssMapping){return content}if(useSourceMap&&typeof btoa==="function"){var sourceMapping=toComment(cssMapping);var sourceURLs=cssMapping.sources.map(function(source){return"/*# sourceURL="+cssMapping.sourceRoot+source+" */"});return[content].concat(sourceURLs).concat([sourceMapping]).join("\n")}return[content].join("\n")}function toComment(sourceMap){var base64=btoa(unescape(encodeURIComponent(JSON.stringify(sourceMap))));var data="sourceMappingURL=data:application/json;charset=utf-8;base64,"+base64;return"/*# "+data+" */"}},1:function(module,exports,__webpack_require__){var stylesInDom={};var memoize=function(fn){var memo;return function(){if(typeof memo==="undefined")memo=fn.apply(this,arguments);return memo}};var isOldIE=memoize(function(){return window&&document&&document.all&&!window.atob});var getTarget=function(target){return document.querySelector(target)};var getElement=function(fn){var memo={};return function(target){if(typeof target==="function"){return target()}if(typeof memo[target]==="undefined"){var styleTarget=getTarget.call(this,target);if(window.HTMLIFrameElement&&styleTarget instanceof window.HTMLIFrameElement){try{styleTarget=styleTarget.contentDocument.head}catch(e){styleTarget=null}}memo[target]=styleTarget}return memo[target]}}();var singleton=null;var singletonCounter=0;var stylesInsertedAtTop=[];var fixUrls=__webpack_require__(2);module.exports=function(list,options){if(typeof DEBUG!=="undefined"&&DEBUG){if(typeof document!=="object")throw new Error("The style-loader cannot be used in a non-browser environment")}options=options||{};options.attrs=typeof options.attrs==="object"?options.attrs:{};if(!options.singleton&&typeof options.singleton!=="boolean")options.singleton=isOldIE();if(!options.insertInto)options.insertInto="head";if(!options.insertAt)options.insertAt="bottom";var styles=listToStyles(list,options);addStylesToDom(styles,options);return function update(newList){var mayRemove=[];for(var i=0;i<styles.length;i++){var item=styles[i];var domStyle=stylesInDom[item.id];domStyle.refs--;mayRemove.push(domStyle)}if(newList){var newStyles=listToStyles(newList,options);addStylesToDom(newStyles,options)}for(var i=0;i<mayRemove.length;i++){var domStyle=mayRemove[i];if(domStyle.refs===0){for(var j=0;j<domStyle.parts.length;j++)domStyle.parts[j]();delete stylesInDom[domStyle.id]}}}};function addStylesToDom(styles,options){for(var i=0;i<styles.length;i++){var item=styles[i];var domStyle=stylesInDom[item.id];if(domStyle){domStyle.refs++;for(var j=0;j<domStyle.parts.length;j++){domStyle.parts[j](item.parts[j])}for(;j<item.parts.length;j++){domStyle.parts.push(addStyle(item.parts[j],options))}}else{var parts=[];for(var j=0;j<item.parts.length;j++){parts.push(addStyle(item.parts[j],options))}stylesInDom[item.id]={id:item.id,refs:1,parts:parts}}}}function listToStyles(list,options){var styles=[];var newStyles={};for(var i=0;i<list.length;i++){var item=list[i];var id=options.base?item[0]+options.base:item[0];var css=item[1];var media=item[2];var sourceMap=item[3];var part={css:css,media:media,sourceMap:sourceMap};if(!newStyles[id])styles.push(newStyles[id]={id:id,parts:[part]});else newStyles[id].parts.push(part)}return styles}function insertStyleElement(options,style){var target=getElement(options.insertInto);if(!target){throw new Error("Couldn't find a style target. This probably means that the value for the 'insertInto' parameter is invalid.")}var lastStyleElementInsertedAtTop=stylesInsertedAtTop[stylesInsertedAtTop.length-1];if(options.insertAt==="top"){if(!lastStyleElementInsertedAtTop){target.insertBefore(style,target.firstChild)}else if(lastStyleElementInsertedAtTop.nextSibling){target.insertBefore(style,lastStyleElementInsertedAtTop.nextSibling)}else{target.appendChild(style)}stylesInsertedAtTop.push(style)}else if(options.insertAt==="bottom"){target.appendChild(style)}else if(typeof options.insertAt==="object"&&options.insertAt.before){var nextSibling=getElement(options.insertInto+" "+options.insertAt.before);target.insertBefore(style,nextSibling)}else{throw new Error("[Style Loader]\n\n Invalid value for parameter 'insertAt' ('options.insertAt') found.\n Must be 'top', 'bottom', or Object.\n (https://github.com/webpack-contrib/style-loader#insertat)\n")}}function removeStyleElement(style){if(style.parentNode===null)return false;style.parentNode.removeChild(style);var idx=stylesInsertedAtTop.indexOf(style);if(idx>=0){stylesInsertedAtTop.splice(idx,1)}}function createStyleElement(options){var style=document.createElement("style");if(options.attrs.type===undefined){options.attrs.type="text/css"}addAttrs(style,options.attrs);insertStyleElement(options,style);return style}function createLinkElement(options){var link=document.createElement("link");if(options.attrs.type===undefined){options.attrs.type="text/css"}options.attrs.rel="stylesheet";addAttrs(link,options.attrs);insertStyleElement(options,link);return link}function addAttrs(el,attrs){Object.keys(attrs).forEach(function(key){el.setAttribute(key,attrs[key])})}function addStyle(obj,options){var style,update,remove,result;if(options.transform&&obj.css){result=options.transform(obj.css);if(result){obj.css=result}else{return function(){}}}if(options.singleton){var styleIndex=singletonCounter++;style=singleton||(singleton=createStyleElement(options));update=applyToSingletonTag.bind(null,style,styleIndex,false);remove=applyToSingletonTag.bind(null,style,styleIndex,true)}else if(obj.sourceMap&&typeof URL==="function"&&typeof URL.createObjectURL==="function"&&typeof URL.revokeObjectURL==="function"&&typeof Blob==="function"&&typeof btoa==="function"){style=createLinkElement(options);update=updateLink.bind(null,style,options);remove=function(){removeStyleElement(style);if(style.href)URL.revokeObjectURL(style.href)}}else{style=createStyleElement(options);update=applyToTag.bind(null,style);remove=function(){removeStyleElement(style)}}update(obj);return function updateStyle(newObj){if(newObj){if(newObj.css===obj.css&&newObj.media===obj.media&&newObj.sourceMap===obj.sourceMap){return}update(obj=newObj)}else{remove()}}}var replaceText=function(){var textStore=[];return function(index,replacement){textStore[index]=replacement;return textStore.filter(Boolean).join("\n")}}();function applyToSingletonTag(style,index,remove,obj){var css=remove?"":obj.css;if(style.styleSheet){style.styleSheet.cssText=replaceText(index,css)}else{var cssNode=document.createTextNode(css);var childNodes=style.childNodes;if(childNodes[index])style.removeChild(childNodes[index]);if(childNodes.length){style.insertBefore(cssNode,childNodes[index])}else{style.appendChild(cssNode)}}}function applyToTag(style,obj){var css=obj.css;var media=obj.media;if(media){style.setAttribute("media",media)}if(style.styleSheet){style.styleSheet.cssText=css}else{while(style.firstChild){style.removeChild(style.firstChild)}style.appendChild(document.createTextNode(css))}}function updateLink(link,options,obj){var css=obj.css;var sourceMap=obj.sourceMap;var autoFixUrls=options.convertToAbsoluteUrls===undefined&&sourceMap;if(options.convertToAbsoluteUrls||autoFixUrls){css=fixUrls(css)}if(sourceMap){css+="\n/*# sourceMappingURL=data:application/json;base64,"+btoa(unescape(encodeURIComponent(JSON.stringify(sourceMap))))+" */"}var blob=new Blob([css],{type:"text/css"});var oldSrc=link.href;link.href=URL.createObjectURL(blob);if(oldSrc)URL.revokeObjectURL(oldSrc)}},2:function(module,exports){module.exports=function(css){var location=typeof window!=="undefined"&&window.location;if(!location){throw new Error("fixUrls requires window.location")}if(!css||typeof css!=="string"){return css}var baseUrl=location.protocol+"//"+location.host;var currentDir=baseUrl+location.pathname.replace(/\/[^\/]*$/,"/");var fixedCss=css.replace(/url\s*\(((?:[^)(]|\((?:[^)(]+|\([^)(]*\))*\))*)\)/gi,function(fullMatch,origUrl){var unquotedOrigUrl=origUrl.trim().replace(/^"(.*)"$/,function(o,$1){return $1}).replace(/^'(.*)'$/,function(o,$1){return $1});if(/^(#|data:|http:\/\/|https:\/\/|file:\/\/\/|\s*$)/i.test(unquotedOrigUrl)){return fullMatch}var newUrl;if(unquotedOrigUrl.indexOf("//")===0){newUrl=unquotedOrigUrl}else if(unquotedOrigUrl.indexOf("/")===0){newUrl=baseUrl+unquotedOrigUrl}else{newUrl=currentDir+unquotedOrigUrl.replace(/^\.\//,"")}return"url("+JSON.stringify(newUrl)+")"});return fixedCss}},21:function(module,__webpack_exports__,__webpack_require__){"use strict";Object.defineProperty(__webpack_exports__,"__esModule",{value:true});var __WEBPACK_IMPORTED_MODULE_0__src_umber__=__webpack_require__(22);FusionCharts.addDep(__WEBPACK_IMPORTED_MODULE_0__src_umber__["a"])},22:function(module,__webpack_exports__,__webpack_require__){"use strict";var __WEBPACK_IMPORTED_MODULE_0__fusioncharts_theme_umber_css__=__webpack_require__(23);var __WEBPACK_IMPORTED_MODULE_0__fusioncharts_theme_umber_css___default=__webpack_require__.n(__WEBPACK_IMPORTED_MODULE_0__fusioncharts_theme_umber_css__);var themeObject={name:"umber",theme:{base:{chart:{showBorder:0,showCanvasBorder:0,bgColor:"#FFF1E5",bgAlpha:100,canvasBgAlpha:0,showAlternateHGridColor:0,showAlternateVGridColor:0,captionFont:"Titillium Web SemiBold",captionFontSize:16,captionFontBold:0,captionFontColor:"#000000",subcaptionFont:"Titillium Web Regular",subCaptionFontSize:12,subCaptionFontBold:0,subcaptionFontColor:"#66605C",captionAlignment:"left",captionPadding:20,xAxisNameFont:"Titillium Web Regular",xAxisNameFontSize:12,xAxisNameFontBold:0,xAxisNameFontColor:"#33302E",yAxisNameFont:"Titillium Web Regular",yAxisNameFontSize:12,yAxisNameFontBold:0,yAxisNameFontColor:"#33302E",sYAxisNameFont:"Titillium Web Regular",sYAxisNameFontSize:12,sYAxisNameFontBold:0,sYAxisNameFontColor:"#33302E",baseFont:"Titillium Web Regular",baseFontColor:"#606060",baseFontSize:11,outCnvBaseFont:"Titillium Web Regular",outCnvBaseFontColor:"#606060",outCnvBaseFontSize:11,showValues:0,placeValuesInside:0,valueFont:"Titillium Web Regular",valueFontSize:11,valueFontColor:"#33302E",legendItemFont:"Titillium Web Regular",legendItemFontSize:12,legendItemFontColor:"#33302E",legendItemHiddenColor:"#D5CDBE",labelDisplay:"auto",divLineColor:"#D5CDBE",divLinealpha:100,divLineThickness:.75,vDivLineColor:"#D5CDBE",vDivLinealpha:100,vDivLineThickness:.75,paletteColors:"#0f5499, #B5323E, #0a5e66, #EDB34A, #676668, #ED9CBD, #4CCBB8, #B9C36C, #749FC0, #FC6D6D",usePlotGradientColor:0,showPlotBorder:0,showShadow:0,use3DLighting:0,tooltipPadding:6,tooltipBgColor:"#FFF9F5",tooltipColor:"#33302E",tooltipBorderRadius:3,tooltipBorderColor:"#D5CDBE",tooltipBorderThickness:.5,tooltipBgAlpha:90,crossLineColor:"#D5CDBE",crossLineAlpha:100,crossLineThickness:1,legendBgAlpha:0,legendBorderThickness:0,legendIconScale:1,drawCustomLegendIcon:1,legendShadow:0,showHoverEffect:1,plotHoverEffect:1,anchorHoverEffect:0,plotFillHoverAlpha:85,plotBorderHoverThickness:0,plotBorderHoverAlpha:0,toolbarButtonColor:"#FFF1E5",toolbarButtonHoverColor:"#FFF9F5",toolbarButtonBorderColor:"#D5CDBE",toolbarButtonBorderThickness:.5,toolbarButtonScale:1.3,transposeAxis:1,setAdaptiveYMin:1,setAdaptiveXMin:1}},column2d:{chart:{paletteColors:"#0f5499"}},column3d:{chart:{paletteColors:"#0f5499",showCanvasBase:0}},line:{chart:{paletteColors:"#0f5499",anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,plotHoverEffect:0}},area2d:{chart:{drawAnchors:0,paletteColors:"#0f5499",plotFillAlpha:85,legendIconBgAlpha:85,legendIconBorderAlpha:0,drawCrossLine:1,anchorBgColor:"#FFF1E5",anchorBorderThickness:2,plotHoverEffect:0}},bar2d:{chart:{paletteColors:"#0f5499"}},bar3d:{chart:{paletteColors:"#0f5499",showCanvasBase:0}},pie2d:{chart:{showLegend:"1",enableMultiSlicing:0,legendIconSides:2,isSmartLineSlanted:0,smartLineColor:"#D5CDBE",smartLineThickness:1,showValues:1,showPercentValues:1,showPercentInToolTip:0}},pie3d:{chart:{showLegend:1,enableMultiSlicing:0,legendIconSides:2,pieYScale:75,pieSliceDepth:10,isSmartLineSlanted:0,smartLineColor:"#D5CDBE",smartLineThickness:1,showValues:1,showPercentValues:1,showPercentInToolTip:0}},doughnut2d:{chart:{showLegend:1,enableMultiSlicing:0,legendIconSides:2,isSmartLineSlanted:0,smartLineColor:"#D5CDBE",smartLineThickness:1,showValues:1,showPercentValues:1,showPercentInToolTip:0,centerLabelFont:"Titillium Web Regular",centerLabelFontSize:12,centerLabelColor:"#33302E",defaultCenterLabel:null,centerLabel:null}},doughnut3d:{chart:{showLegend:1,enableMultiSlicing:0,legendIconSides:2,pieYScale:75,pieSliceDepth:10,isSmartLineSlanted:0,smartLineColor:"#D5CDBE",smartLineThickness:1,showValues:1,showPercentValues:1,showPercentInToolTip:0}},pareto2d:{chart:{paletteColors:"#0f5499",lineColor:"#B5323E",anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2}},pareto3d:{chart:{paletteColors:"#0f5499",lineColor:"#B5323E",anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,showCanvasBase:0}},mscolumn2d:{chart:{drawCrossLine:1}},mscolumn3d:{chart:{showCanvasBase:0}},msline:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,plotHoverEffect:0}},msbar2d:{chart:{drawCrossLine:1}},msbar3d:{chart:{showCanvasBase:0}},msarea:{chart:{drawAnchors:0,anchorBgColor:"#FFF1E5",plotFillAlpha:50,legendIconBgAlpha:50,legendIconBorderAlpha:0,legendIconSides:2,drawCrossLine:1,anchorBorderThickness:2,plotHoverEffect:0}},marimekko:{chart:{showSum:0,valueBgColor:"FFF9F5",valueFontColor:"#33302E",valueFontSize:12,valueBorderThickness:.5,valueBorderColor:"#D5CDBE",valueBorderRadius:3,showPlotBorder:1,plotborderThickness:.5,plotBorderColor:"#D5CDBE"}},zoomline:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,flatscrollbars:1,scrollHeight:17,scrollColor:"#F2E5D9"}},zoomlinedy:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,flatscrollbars:1,scrollHeight:17,scrollColor:"#F2E5D9"}},stackedcolumn2d:{chart:{drawCrossLine:1}},stackedcolumn3d:{chart:{showCanvasBase:0}},stackedbar2d:{chart:{drawCrossLine:1}},stackedbar3d:{chart:{showCanvasBase:0}},stackedarea2d:{chart:{drawAnchors:0,anchorBgColor:"#FFF1E5",plotFillAlpha:85,legendIconBgAlpha:85,legendIconBorderAlpha:0,legendIconSides:2,drawCrossLine:1,anchorBorderThickness:2,plotHoverEffect:0}},msstackedcolumn2d:{chart:{drawCrossLine:1}},mscombi2d:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2}},mscombi3d:{chart:{showCanvasBase:0,anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2}},mscolumnline3d:{chart:{showCanvasBase:0,anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2}},stackedcolumn2dline:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2}},stackedcolumn3dline:{chart:{showCanvasBase:0,anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2}},mscombidy2d:{chart:{anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,drawCrossLine:1}},mscolumn3dlinedy:{chart:{showCanvasBase:0,anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2}},stackedcolumn3dlinedy:{chart:{showCanvasBase:0,anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2}},msstackedcolumn2dlinedy:{chart:{anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,drawCrossLine:1}},scatter:{chart:{anchorBgColor:"#FFF1E5",drawCustomLegendIcon:0,anchorBorderThickness:2,legendIconBorderThickness:2}},bubble:{chart:{plotFillAlpha:85,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,quadrantLineThickness:1.5,quadrantLineColor:"#33302E",quadrantLineDashed:1,quadrantLineAlpha:100,quadrantLineDashGap:2,quadrantLineDashLen:2,quadrantLabelFont:"Titillium Web Regular",quadrantLabelFontSize:12,quadrantLabelFontBold:0,quadrantLabelFontColor:"#33302E",plotFillHoverAlpha:60}},zoomscatter:{chart:{plotFillAlpha:85,anchorRadius:4,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,quadrantLineThickness:1.5,quadrantLineColor:"#33302E",quadrantLineDashed:1,quadrantLineAlpha:100,quadrantLineDashGap:2,quadrantLineDashLen:2,quadrantLabelFont:"Titillium Web Regular",quadrantLabelFontSize:12,quadrantLabelFontBold:0,quadrantLabelFontColor:"#33302E",plotFillHoverAlpha:60}},scrollcolumn2d:{chart:{drawCrossLine:1,flatscrollbars:1,scrollHeight:17,scrollColor:"#F2E5D9"}},scrollline2d:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,flatscrollbars:1,scrollHeight:17,scrollColor:"#F2E5D9",plotHoverEffect:0}},scrollarea2d:{chart:{drawAnchors:0,anchorBgColor:"#FFF1E5",plotFillAlpha:50,legendIconBgAlpha:50,legendIconBorderAlpha:0,legendIconSides:2,drawCrossLine:1,flatscrollbars:1,scrollHeight:17,scrollColor:"#F2E5D9",plotHoverEffect:0}},scrollstackedcolumn2d:{chart:{drawCrossLine:1,flatscrollbars:1,scrollHeight:17,scrollColor:"#F2E5D9"}},scrollcombi2d:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,flatscrollbars:1,scrollHeight:17,scrollColor:"#F2E5D9"}},scrollcombidy2d:{chart:{anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,drawCrossLine:1,flatscrollbars:1,scrollHeight:17,scrollColor:"#F2E5D9"}},angulargauge:{chart:{captionAlignment:"center",setAdaptiveMin:1,adjustTM:1,tickvaluedistance:5,placeTicksInside:0,autoAlignTickValues:1,showGaugeBorder:0,minortmnumber:0,majorTMHeight:10,majorTMColor:"D5CDBE",gaugeFillMix:"{light-0}",pivotbgcolor:"#33302E",pivotfillmix:0,showpivotborder:1,pivotBorderColor:"#D5CDBE",showValue:0,valueBelowPivot:1,valueFont:"Titillium Web SemiBold",valueFontSize:12,valueFontColor:"#33302E"},dials:{dial:[{bgColor:"#33302E",borderThickness:0}]}},bulb:{chart:{captionAlignment:"center",is3D:0,placeValuesInside:1,valueFont:"Titillium Web SemiBold",valueFontSize:12,valueFontColor:"#33302E"}},cylinder:{chart:{cylRadius:50,cylYScale:30,cylFillColor:"#0f5499",cylGlassColor:"#FFF9F5",majorTMHeight:10,majorTMColor:"#D5CDBE",minortmnumber:0,showValue:1,valueFont:"Titillium Web SemiBold",valueFontSize:12,valueFontColor:"#33302E",baseFontColor:"#33302E"}},hled:{chart:{captionAlignment:"center",setAdaptiveMin:1,showGaugeBorder:0,adjustTM:1,placeTicksInside:0,autoAlignTickValues:1,minortmnumber:0,majorTMHeight:10,majorTMColor:"#D5CDBE",ledGap:0,valueFont:"Titillium Web SemiBold",valueFontSize:12,valueFontColor:"#33302E",baseFontColor:"#33302E"}},hlineargauge:{chart:{captionAlignment:"center",showGaugeBorder:0,setAdaptiveMin:1,adjustTM:1,placeTicksInside:0,autoAlignTickValues:1,minortmnumber:0,majorTMHeight:10,majorTMColor:"#D5CDBE",gaugeFillMix:"{light-0}",valueFont:"Titillium Web SemiBold",valueFontSize:12,valueFontColor:"#33302E",baseFontColor:"#33302E"}},thermometer:{chart:{manageResize:1,autoScale:1,showGaugeBorder:1,gaugeBorderColor:"#D5CDBE",gaugeBorderThickness:2,gaugeBorderAlpha:100,thmFillColor:"#0f5499",thmGlassColor:"#FFF9F5",placeTicksInside:0,autoAlignTickValues:1,minortmnumber:0,majorTMHeight:10,majorTMColor:"#D5CDBE",valueFont:"Titillium Web SemiBold",valueFontSize:12,valueFontColor:"#33302E",baseFontColor:"#33302E"}},vled:{chart:{captionAlignment:"center",setAdaptiveMin:1,showGaugeBorder:0,adjustTM:1,placeTicksInside:0,autoAlignTickValues:1,minortmnumber:0,majorTMHeight:10,majorTMColor:"#D5CDBE",ledGap:0,valueFont:"Titillium Web SemiBold",valueFontSize:12,valueFontColor:"#33302E",baseFontColor:"#33302E"}},realtimearea:{chart:{drawAnchors:0,anchorBgColor:"#FFF1E5",plotFillAlpha:50,legendIconBgAlpha:50,legendIconBorderAlpha:0,legendIconSides:2,realTimeValueFont:"Titillium Web SemiBold",realTimeValueFontSize:12,realTimeValueFontColor:"#33302E"}},realtimecolumn:{chart:{realTimeValueFont:"Titillium Web SemiBold",realTimeValueFontSize:12,realTimeValueFontColor:"#33302E"}},realtimeline:{chart:{anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,realTimeValueFont:"Titillium Web SemiBold",realTimeValueFontSize:12,realTimeValueFontColor:"#33302E"}},realtimestackedarea:{chart:{drawAnchors:0,anchorBgColor:"#FFF1E5",plotFillAlpha:85,legendIconBgAlpha:85,legendIconBorderAlpha:0,legendIconSides:2,realTimeValueFont:"Titillium Web SemiBold",realTimeValueFontSize:12,realTimeValueFontColor:"#33302E"}},realtimestackedcolumn:{chart:{realTimeValueFont:"Titillium Web SemiBold",realTimeValueFontSize:12,realTimeValueFontColor:"#33302E"}},realtimelinedy:{chart:{anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,realTimeValueFont:"Titillium Web SemiBold",realTimeValueFontSize:12,realTimeValueFontColor:"#33302E"}},sparkline:{chart:{captionPosition:"middle",plotFillColor:"#0F5499",lineAlpha:85,plotFillHoverColor:"#D5CDBE",lineThickness:2,anchorRadius:4,anchorBorderThickness:2,highColor:"#0A5E66",lowColor:"#B5323E",showOpenAnchor:0,showCloseAnchor:0,showOpenValue:0,showCloseValue:0,showHighLowValue:0,periodColor:"#D5CDBE",chartLeftMargin:5,chartRightMargin:5}},sparkcolumn:{chart:{captionPosition:"middle",plotFillColor:"#0F5499",highColor:"#0A5E66",lowColor:"#B5323E",periodColor:"#D5CDBE",chartLeftMargin:5}},sparkwinloss:{chart:{captionPosition:"middle",winColor:"#0A5E66",lossColor:"#B5323E",drawColor:"#EDB34A",scoreLessColor:"#0F5499",periodColor:"#D5CDBE",chartLeftMargin:5}},hbullet:{chart:{plotFillColor:"#0F5499",colorRangeFillMix:"{light-0}",targetColor:"#000000",targetThickness:"2",targetCapStyle:"round",showTickMarks:0,showTickValues:1,showLimits:1,valueFont:"Titillium Web SemiBold",valueFontSize:12,valueFontColor:"#33302E",baseFontColor:"#33302E"}},vbullet:{chart:{plotFillColor:"#0F5499",colorRangeFillMix:"{light-0}",targetColor:"#000000",targetThickness:"2",targetCapStyle:"round",showTickMarks:0,showTickValues:1,showLimits:1,valueFont:"Titillium Web SemiBold",valueFontSize:12,valueFontColor:"#33302E",baseFontColor:"#33302E"}},funnel:{chart:{is2D:1,isSmartLineSlanted:0,smartLineColor:"#D5CDBE",smartLineThickness:1,streamlinedData:1,useSameSlantAngle:1,showLegend:1,legendPosition:"right",showLabels:0}},pyramid:{chart:{is2D:1,isSmartLineSlanted:0,smartLineColor:"#D5CDBE",smartLineThickness:1,streamlinedData:1,useSameSlantAngle:1,showLegend:1,legendPosition:"right",showLabels:0,plotBorderThickness:0}},gantt:{chart:{taskBarFillMix:"{light+0}",flatScrollBars:1,scrollHeight:17,scrollColor:"#F2E5D9",gridBorderAlpha:100,gridBorderColor:"#D5CDBE",ganttLineColor:"#D5CDBE",ganttLineAlpha:100,taskBarRoundRadius:3,showHoverEffect:1,plotHoverEffect:1,plotFillHoverAlpha:85,showCategoryHoverBand:1,categoryHoverBandAlpha:85,showGanttPaneVerticalHoverBand:1,showProcessHoverBand:1,processHoverBandAlpha:85,showGanttPaneHorizontalHoverBand:1,showConnectorHoverEffect:1,connectorHoverAlpha:85,showTaskHoverEffect:1,taskHoverFillAlpha:85,slackHoverFillAlpha:85,scrollShowButtons:1,showCanvasBorder:1,canvasBorderColor:"#D5CDBE",canvasBorderThickness:.75},categories:[{fontcolor:"#33302E",fontsize:12,bgcolor:"#FFF9F5",hoverBandAlpha:85,showGanttPaneHoverBand:1,showHoverBand:1,category:[{fontcolor:"#33302E",fontsize:11,bgAlpha:85,bgcolor:"#FFF9F5"}]}],tasks:{showBorder:0,showHoverEffect:0,task:[{color:"#0f5499"}]},processes:{fontcolor:"#33302E",isanimated:0,bgcolor:"#FFF9F5",bgAlpha:85,headerbgcolor:"#FFF9F5",headerfontcolor:"#33302E",showGanttPaneHoverBand:1,showHoverBand:1},text:{fontcolor:"#33302E",bgcolor:"#FFF9F5"},datatable:{fontcolor:"#33302E",bgcolor:"#FFF9F5",datacolumn:[{bgcolor:"#FFF9F5"}]},connectors:[{hoverThickness:1}],milestones:{milestone:[{color:"#33302E"}]}},logmscolumn2d:{chart:{drawCrossLine:1}},logmsline:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2}},spline:{chart:{paletteColors:"#0f5499",anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2}},splinearea:{chart:{drawAnchors:0,paletteColors:"#0f5499",plotFillAlpha:85,legendIconBgAlpha:85,legendIconBorderAlpha:0,drawCrossLine:1,anchorBgColor:"#FFF1E5",anchorBorderThickness:2,plotHoverEffect:0}},msspline:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2}},mssplinearea:{chart:{drawAnchors:0,anchorBgColor:"#FFF1E5",plotFillAlpha:50,legendIconBgAlpha:50,legendIconBorderAlpha:0,legendIconSides:2,drawCrossLine:1,anchorBorderThickness:2,plotHoverEffect:0}},errorbar2d:{chart:{errorBarColor:"#33302E",errorBarThickness:1}},errorline:{chart:{anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,errorBarColor:"#33302E",errorBarThickness:1}},errorscatter:{chart:{anchorBgColor:"#FFF1E5",drawCustomLegendIcon:0,anchorBorderThickness:2,legendIconBorderThickness:2,errorBarColor:"#33302E",errorBarThickness:1}},inversemsarea:{chart:{drawAnchors:0,anchorBgColor:"#FFF1E5",plotFillAlpha:50,legendIconBgAlpha:50,legendIconBorderAlpha:0,legendIconSides:2,drawCrossLine:1,anchorBorderThickness:2,plotHoverEffect:0}},inversemscolumn2d:{chart:{drawCrossLine:1}},inversemsline:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,plotHoverEffect:0}},dragcolumn2d:{chart:{},categories:[{category:[{fontItalic:1}]}],dataset:[{data:[{allowDrag:1,alpha:85}]}]},dragline:{chart:{anchorBgColor:"#FFF1E5",lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,plotHoverEffect:0},categories:[{category:[{fontItalic:1}]}],dataset:[{data:[{allowDrag:1,alpha:85,dashed:1}]}]},dragarea:{chart:{drawAnchors:0,anchorBgColor:"#FFF1E5",plotFillAlpha:50,legendIconBgAlpha:50,legendIconBorderAlpha:0,legendIconSides:2,anchorBorderThickness:2,plotHoverEffect:0},categories:[{category:[{fontItalic:1}]}],dataset:[{data:[{drawAnchors:1,allowDrag:1,dashed:1}]}]},treemap:{chart:{parentLabelLineHeight:12.5,baseFontSize:11,labelFontSize:11,showParent:1,showNavigationBar:0,plotBorderThickness:.5,plotBorderColor:"#D5CDBE",labelGlow:0,btnBackChartTooltext:"Back",btnResetChartTooltext:"Home",legendScaleLineThickness:0,legendaxisborderalpha:0,legendPointerColor:"#FFF9F5",legendpointerbordercolor:"#606060",legendPointerAlpha:85,defaultParentBgColor:"#FFF9F5",fontcolor:"#33302E"},data:[{fillcolor:"#FFF9F5",data:[{fillcolor:"#FFF9F5"}]}]},radar:{chart:{drawAnchors:1,anchorBgColor:"#FFF1E5",plotFillAlpha:50,legendIconBgAlpha:50,legendIconBorderAlpha:0,legendIconSides:2,anchorBorderThickness:2,radarFillColor:"#FFF9F5",radarBorderThickness:0}},heatmap:{chart:{showPlotBorder:1,plotBorderThickness:.5,plotBorderColor:"#D5CDBE",tlFontColor:"#606060",tlFontSize:10,trFontColor:"#606060",trFontSize:10,blFontColor:"#606060",blFontSize:10,brFontColor:"#606060",brFontSize:10,legendScaleLineThickness:0,legendaxisborderalpha:0,legendPointerColor:"#FFF9F5",legendpointerbordercolor:"#606060",legendPointerAlpha:85,showCanvasBorder:1,canvasBorderThickness:.5,canvasBorderColor:"#D5CDBE"},colorrange:{gradient:1,code:"#0f5499"}},boxandwhisker2d:{chart:{drawCustomLegendIcon:0,showLegend:1,showDetailedLegend:1,legendIconSides:2,showPlotBorder:0,upperBoxBorderAlpha:0,lowerBoxBorderAlpha:0,lowerQuartileAlpha:0,upperQuartileAlpha:0,upperWhiskerThickness:1,upperWhiskerColor:"#33302E",lowerWhiskerColor:"#33302E",lowerWhiskerThickness:1,medianColor:"#000000",medianThickness:1,outliericonshape:"circle",outliericonsides:4,meaniconcolor:"#000000",meanIconShape:"circle",meaniconsides:2,meaniconradius:3}},candlestick:{chart:{showVPlotBorder:1,vplotborderThickness:.5,plotborderThickness:.5,bearFillColor:"#B5323E",bearBorderColor:"#B5323E",bullFillColor:"#FFF9F5",bullBorderColor:"#606060",plotLineThickness:.75,plotLineAlpha:100,divLineDashed:0,showDetailedLegend:1,legendIconSides:4,showHoverEffect:1,plotHoverEffect:1,trendLineColor:"#000000",trendLineThickness:1,trendValueAlpha:100,rollOverBandAlpha:100,rollOverBandColor:"#D5CDBE"},categories:[{verticalLineColor:"#D5CDBE",verticalLineThickness:1}]},dragnode:{chart:{showDetailedLegend:1,legendIconSides:2,divLineAlpha:0,numDivLines:0,valueFontColor:"#FFFFFF"},dataset:[{color:"#0F5499"}],connectors:[{connector:[{color:"#33302E"}]}]},msstepLine:{chart:{anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,plotHoverEffect:0}},multiaxisline:{chart:{drawAnchors:0,anchorBgColor:"#FFF1E5",drawCrossLine:1,lineThickness:2,anchorBorderThickness:2,legendIconSides:2,legendIconBorderThickness:2,allowSelection:0,plotHoverEffect:0},axis:[{divLineColor:"#D5CDBE",divLineThickness:.75,setAdaptiveYMin:"1"}]},multilevelpie:{chart:{useHoverColor:0,valueFontColor:"#FFFFFF",showPlotBorder:1,plotborderThickness:.5,plotBorderColor:"#D5CDBE"},category:[{color:"#33302E",category:[{color:"#0F5499",alpha:85,category:[{color:"#0F5499",alpha:70,category:[{color:"#0F5499",alpha:55}]}]}]}]},selectscatter:{chart:{anchorBgColor:"#FFF1E5",drawCustomLegendIcon:0,anchorBorderThickness:2,legendIconBorderThickness:2}},waterfall2d:{chart:{paletteColors:"#0F5499",positiveColor:"#0A5E66",negativeColor:"#B5323E",showConnectors:1,connectorColor:"#33302E",connectorThickness:1}},kagi:{chart:{rallyThickness:2,declineThickness:2,legendIconSides:2,drawAnchors:0,rallyColor:"#0A5E66",declineColor:"#B5323E"}},geo:{chart:{showLabels:0,legendScaleLineThickness:0,legendaxisborderalpha:0,legendPointerColor:"#FFF9F5",legendpointerbordercolor:"#606060",legendPointerAlpha:85,fillColor:"#0f5499",showEntityHoverEffect:1,entityFillHoverAlpha:85,connectorHoverAlpha:85,markerBorderHoverAlpha:85,showBorder:1,borderColor:"#D5CDBE",borderThickness:.5,nullEntityColor:"FFF9F5",entityFillHoverColor:"#606060"},colorrange:{gradient:1,code:"#0f5499"}},overlappedbar2d:{chart:{drawCrossLine:1}},overlappedcolumn2d:{chart:{drawCrossLine:1}},timeseries:{chart:{baseFont:"Titillium Web Regular",style:{text:{"font-family":"Titillium Web Regular"},background:{fill:"#FFF1E5"},canvas:{fill:"#FFF1E5",stroke:"#D5CDBE","stroke-width":.75}}},tooltip:{style:{container:{"background-color":"#FFF9F5",opacity:.9,border:"0.5px solid #D5CDBE","border-radius":"3px",padding:"6px"},text:{"font-size":"11px",color:"#606060"},header:{"font-family":"Titillium Web SemiBold","font-size":"12px",color:"#33302E",padding:"0px"},body:{padding:"0px"}}},navigator:{scrollbar:{style:{button:{fill:"#D5CDBE"},track:{fill:"#F2E5D9"},scroller:{fill:"#D5CDBE"}}},window:{style:{handle:{fill:"#D5CDBE"},mask:{opacity:.5,stroke:"#D5CDBE","stroke-width":.75}}}},crossline:{style:{line:{stroke:"#D5CDBE","stroke-width":1}}},caption:{style:{text:{"font-size":16,"font-family":"Titillium Web SemiBold",fill:"#000000"}}},subcaption:{style:{text:{"font-size":12,"font-family":"Titillium Web Regular",fill:"#66605C"}}},plotconfig:{column:{style:{"plot:hover":{opacity:.85},"plot:highlight":{opacity:.85}}},line:{style:{plot:{"stroke-width":2}}},candlestick:{style:{bear:{stroke:"#B5323E",fill:"#B5323E"},"bear:hover":{opacity:.85},"bear:highlight":{opacity:.85},bull:{stroke:"#606060",fill:"#FFF9F5"},"bull:hover":{opacity:.85},"bull:highlight":{opacity:.85}}},ohlc:{style:{bear:{stroke:"#B5323E",fill:"#B5323E"},"bear:hover":{opacity:.85},"bear:highlight":{opacity:.85},bull:{stroke:"#606060",fill:"#FFF9F5"},"bull:hover":{opacity:.85},"bull:highlight":{opacity:.85}}}},yaxis:[{referenceline:[{style:{marker:{fill:"#33302E",stroke:"#33302E","stroke-width":1.5}}}],style:{title:{"font-size":12,fill:"#33302E"},"tick-mark":{stroke:"#D5CDBE","stroke-width":.75},"grid-line":{stroke:"#D5CDBE","stroke-width":.75},label:{color:"#606060"}}}],xaxis:{style:{title:{"font-size":12,fill:"#33302E"},"tick-mark-major":{stroke:"#D5CDBE","stroke-width":.75},"tick-mark-minor":{stroke:"#D5CDBE","stroke-width":.5},"label-major":{color:"#606060"},"label-minor":{color:"#606060"},"label-context":{color:"#000000"},"grid-line":{stroke:"#D5CDBE","stroke-width":.75}}},legend:{item:{style:{text:{fill:"#33302E","font-size":12}}}},extensions:{standardRangeSelector:{style:{"button-text":{fill:"#66605C","font-family":"Titillium Web Regular"},"button-text:hover":{fill:"#33302E","font-family":"Titillium Web SemiBold"},"button-text:active":{fill:"#33302E","font-family":"Titillium Web SemiBold"},separator:{stroke:"#D5CDBE","stroke-width":.75}}},customRangeSelector:{style:{"title-text":{fill:"#33302E","font-family":"Titillium Web SemiBold"},"title-icon":{fill:"#33302E","font-family":"Titillium Web SemiBold"},container:{"background-color":"#FFF1E5"},label:{color:"#33302E","font-family":"Titillium Web SemiBold"},input:{"background-color":"#FFF9F5",border:"0.5px solid #D5CDBE","border-radius":"3px",color:"#33302E","font-family":"Titillium Web Regular"},select:{"background-color":"#FFF9F5",border:"0.5px solid #D5CDBE","border-radius":"3px",color:"#33302E"},"button-apply":{color:"#FFFFFF","background-color":"#33302E",border:"none"},"button-cancel":{color:"#33302E","background-color":"#FFF1E5",border:"none"},"button-apply:hover":{"font-family":"Titillium Web SemiBold"},"button-cancel:hover":{"font-family":"Titillium Web SemiBold"},"cal-header":{"background-color":"#000000","font-family":"Titillium Web Regular"},"cal-navprev":{"font-family":"Titillium Web Regular","font-size":"12px"},"cal-navnext":{"font-family":"Titillium Web Regular","font-size":"12px"},"cal-weekend":{"background-color":"#00000040"},"cal-days":{"background-color":"#fff1e5",color:"#33302e","font-family":"Titillium Web Regular",border:"none"},"cal-date":{"background-color":"#fff1e5",color:"#33302e","font-family":"Titillium Web Regular",border:"none"},"cal-date:hover":{"background-color":"#000000",color:"#ffffff","font-family":"Titillium Web Regular",border:"none"},"cal-disableddate":{"background-color":"#fff1e5",color:"#33302e80","font-family":"Titillium Web Regular",border:"none"},"cal-disableddate:hover":{"background-color":"#fff1e5",color:"#33302e80","font-family":"Titillium Web Regular",border:"none"},"cal-selecteddate":{"background-color":"#000000",color:"#ffffff","font-family":"Titillium Web Regular"}}}}}}};__webpack_exports__["a"]={extension:themeObject,name:"umberTheme",type:"theme"}},23:function(module,exports,__webpack_require__){var content=__webpack_require__(24);if(typeof content==="string")content=[[module.i,content,""]];var transform;var insertInto;var options={hmr:true};options.transform=transform;options.insertInto=undefined;var update=__webpack_require__(1)(content,options);if(content.locals)module.exports=content.locals;if(false){module.hot.accept("!!../../../node_modules/css-loader/index.js!./fusioncharts.theme.umber.css",function(){var newContent=require("!!../../../node_modules/css-loader/index.js!./fusioncharts.theme.umber.css");if(typeof newContent==="string")newContent=[[module.id,newContent,""]];var locals=function(a,b){var key,idx=0;for(key in a){if(!b||a[key]!==b[key])return false;idx++}for(key in b)idx--;return idx===0}(content.locals,newContent.locals);if(!locals)throw new Error("Aborting CSS HMR due to changed css-modules locals.");update(newContent)});module.hot.dispose(function(){update()})}},24:function(module,exports,__webpack_require__){exports=module.exports=__webpack_require__(0)(false);exports.push([module.i,'@font-face {\n  font-family: "Titillium Web Regular";\n  font-style: normal;\n  font-weight: 400;\n  src: local("Titillium Web Regular"), local("TitilliumWeb-Regular"),\n    url(https://fonts.gstatic.com/s/titilliumweb/v7/NaPecZTIAOhVxoMyOr9n_E7fdMPmDaZRbrw.woff2)\n      format("woff2");\n  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA,\n    U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215,\n    U+FEFF, U+FFFD;\n}\n\n@font-face {\n  font-family: "Titillium Web SemiBold";\n  font-style: normal;\n  font-weight: 600;\n  src: local("Titillium Web SemiBold"), local("TitilliumWeb-SemiBold"),\n    url(https://fonts.gstatic.com/s/titilliumweb/v7/NaPDcZTIAOhVxoMyOr9n_E7ffBzCGItzY5abuWI.woff2)\n      format("woff2");\n  unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA,\n    U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215,\n    U+FEFF, U+FFFD;\n}',""])}})});
//# sourceMappingURL=fusioncharts.theme.umber.js.map