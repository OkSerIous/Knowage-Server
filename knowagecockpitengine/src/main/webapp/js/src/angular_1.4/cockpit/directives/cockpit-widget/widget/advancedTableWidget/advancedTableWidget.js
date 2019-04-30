/*
Knowage, Open Source Business Intelligence suite
Copyright (C) 2016 Engineering Ingegneria Informatica S.p.A.

Knowage is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

Knowage is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
(function() {
	angular
		.module('cockpitModule')
		.directive('cockpitAdvancedTableWidget',function(){
			return{
				templateUrl: baseScriptPath+ '/directives/cockpit-widget/widget/advancedTableWidget/templates/advancedTableWidgetTemplate.html',
				controller: cockpitAdvancedTableWidgetControllerFunction,
				compile: function (tElement, tAttrs, transclude) {
					return {
						pre: function preLink(scope, element, attrs, ctrl, transclud) {
							
						},
						post: function postLink(scope, element, attrs, ctrl, transclud) {
							element.ready(function () {
	                    		scope.initWidget();
	                        });
						}
					};
				}
			}
		})
	function cockpitAdvancedTableWidgetControllerFunction(
			$scope,
			$mdDialog,
			$mdToast,
			$timeout,
			$mdPanel,
			$q,
			$sce,
			$filter,
			sbiModule_config,
			sbiModule_translate,
			sbiModule_restServices,
			cockpitModule_datasetServices,
			cockpitModule_generalOptions,
			cockpitModule_widgetConfigurator,
			cockpitModule_widgetServices,
			cockpitModule_widgetSelection,
			cockpitModule_analyticalDrivers,
			cockpitModule_properties){
		
		$scope.showGrid = true;
		var _rowHeight;
		if(!$scope.ngModel.settings){
			$scope.ngModel.settings = {
				"pagination" : {
					'enabled': true,
					'itemsNumber': 10,
					'frontEnd': false
				},
				"page":1
			};
		}else $scope.ngModel.settings.page = 1;
		
		if(!$scope.ngModel.style) $scope.ngModel.style = {"th":{},"tr":{}}; 
		
		function getColumns(fields) {
			var columns = [];
			for(var c in $scope.ngModel.content.columnSelectedOfDataset){
				for(var f in fields){
					if(typeof fields[f] == 'object' && $scope.ngModel.content.columnSelectedOfDataset[c].alias === fields[f].header){
						var tempCol = {"headerName":$scope.ngModel.content.columnSelectedOfDataset[c].aliasToShow || $scope.ngModel.content.columnSelectedOfDataset[c].alias,"field":fields[f].name};
						if(!$scope.ngModel.content.columnSelectedOfDataset[c].hideTooltip) tempCol.tooltipField = fields[f].name;
						if($scope.ngModel.content.columnSelectedOfDataset[c].style) tempCol.style = $scope.ngModel.content.columnSelectedOfDataset[c].style;
						if($scope.ngModel.content.columnSelectedOfDataset[c].style && $scope.ngModel.content.columnSelectedOfDataset[c].style.hiddenColumn) tempCol.hide = true;
						if($scope.ngModel.settings.summary && $scope.ngModel.settings.summary.enabled) {
							tempCol.pinnedRowCellRenderer = SummaryRowRenderer,
							tempCol.pinnedRowCellRendererParams = {"title":$scope.ngModel.settings.summary.title, "style": $scope.ngModel.settings.summary.style};
						}
						if($scope.ngModel.content.columnSelectedOfDataset[c].style && $scope.ngModel.content.columnSelectedOfDataset[c].style.width) {
							tempCol.width = parseInt($scope.ngModel.content.columnSelectedOfDataset[c].style.width);
							tempCol.suppressSizeToFit = true;
						}
						if($scope.ngModel.content.columnSelectedOfDataset[c].ranges) tempCol.ranges = $scope.ngModel.content.columnSelectedOfDataset[c].ranges;
						tempCol.fieldType = $scope.ngModel.content.columnSelectedOfDataset[c].type;
						if($scope.ngModel.content.columnSelectedOfDataset[c].momentDateFormat) tempCol.dateFormat = $scope.ngModel.content.columnSelectedOfDataset[c].momentDateFormat;
						tempCol.headerComponentParams = {template: headerTemplate()};
						tempCol.cellStyle = getCellStyle;
						tempCol.cellRenderer = cellRenderer;
						if($scope.ngModel.settings.autoRowsHeight) {
							tempCol.autoHeight = true;
							if(tempCol.style) tempCol.style['white-space'] = 'normal';
							else tempCol.style = {'white-space':'normal'};
						}else if(tempCol.style) tempCol.style['white-space'] = 'nowrap';
						tempCol.autoHeight = $scope.ngModel.settings.autoRowsHeight || false,
						columns.push(tempCol);
						break;
					}
				}
			}
			return columns
		}
		
		function getColumnName(colNum){
			for(var k in $scope.metadata.fields){
				if($scope.metadata.fields[k].dataIndex && $scope.metadata.fields[k].dataIndex == colNum) return $scope.metadata.fields[k].header;
			}
		}
		
		function headerTemplate() { 
			return 	'<div class="ag-cell-label-container" role="presentation" style="background-color:'+$scope.ngModel.style.th["background-color"]+'">'+
					'	 <span ref="eMenu" class="ag-header-icon ag-header-cell-menu-button"></span>'+
					'    <div ref="eLabel" class="ag-header-cell-label" role="presentation"  style="justify-content:'+$scope.ngModel.style.th["justify-content"]+'">'+
					'       <span ref="eText" class="ag-header-cell-text" role="columnheader" style="color:'+$scope.ngModel.style.th.color+';font-style:'+$scope.ngModel.style.th["font-style"]+';font-size:'+$scope.ngModel.style.th["font-size"]+';font-weight:'+$scope.ngModel.style.th["font-weight"]+'"></span>'+
					'       <span ref="eFilter" class="ag-header-icon ag-filter-icon"></span>'+
					'       <span ref="eSortOrder" class="ag-header-icon ag-sort-order" ></span>'+
					'    	<span ref="eSortAsc" class="ag-header-icon ag-sort-ascending-icon" ></span>'+
					'   	<span ref="eSortDesc" class="ag-header-icon ag-sort-descending-icon" ></span>'+
					'  		<span ref="eSortNone" class="ag-header-icon ag-sort-none-icon" ></span>'+
					'	</div>'+
					'</div>';
		}
		
		function getCellStyle(params){
			var tempStyle = params.colDef.style || {};
			if(params.colDef.ranges && params.colDef.ranges.length > 0){
				for(var k in params.colDef.ranges){
					if (params.value!="" && eval(params.value + params.colDef.ranges[k].operator + params.colDef.ranges[k].value)) {
						tempStyle['background-color'] = params.colDef.ranges[k]['background-color'] || '';
						tempStyle['color'] = params.colDef.ranges[k]['color'] || '';
                        if (params.colDef.ranges[k].operator == '==') break;
                    }
				}
			}
			return tempStyle;
		}
		
		function cellRenderer(params){
			var tempValue = params.value;
			var tempValueType = cockpitModule_generalOptions.typesMap[params.colDef.fieldType].label;
			if(tempValueType == 'date') {
				tempValue = isNaN(moment(params.value,'DD/MM/YYYY')) ? params.value : moment(params.value,'DD/MM/YYYY').locale(sbiModule_config.curr_language).format(params.colDef.dateFormat || 'LL');
			}
			if(tempValueType == 'timestamp') {
				tempValue = isNaN(moment(params.value,'DD/MM/YYYY HH:mm:ss.SSS'))? params.value : moment(params.value,'DD/MM/YYYY HH:mm:ss.SSS').locale(sbiModule_config.curr_language).format(params.colDef.dateFormat || 'LLL');
			}
			if(tempValueType == 'float' || tempValueType == 'integer') {
				if(params.colDef.style && !params.colDef.style.asString) {
					var defaultPrecision = (tempValueType == 'float') ? 2 : 0;
					tempValue = $filter('number')(params.value, (params.colDef.style && typeof params.colDef.style.precision != 'undefined') ? params.colDef.style.precision : defaultPrecision);
				}
			}
			if(params.colDef.ranges && params.colDef.ranges.length > 0){
				for(var k in params.colDef.ranges){
					if (params.value!="" && eval(params.value + params.colDef.ranges[k].operator + params.colDef.ranges[k].value)) {
						tempValue = '<i class="'+params.colDef.ranges[k].icon+'"></i>'
                        if (params.colDef.ranges[k].operator == '==') break;
                    }
				}
			}
			return ((params.colDef.style && params.colDef.style.prefix) || '') + tempValue + ((params.colDef.style && params.colDef.style.suffix) || '');
		}
		
		function SummaryRowRenderer () {}

		SummaryRowRenderer.prototype.init = function(params) {
		    this.eGui = document.createElement('div');
		    this.eGui.style.color = (params.style && params.style.color) || "";
		    this.eGui.style.backgroundColor = (params.style && params.style['background-color']) || "";
		    this.eGui.style.fontSize = (params.style && params.style['font-size']) || "";
		    this.eGui.style.fontWeight = (params.style && params.style['font-weight']) || "";;
		    this.eGui.style.fontStyle = (params.style && params.style['font-style']) || "";
		    if(cellRenderer(params)){
		    	this.eGui.innerHTML = params.title ? '<b style="margin-right: 4px;">'+params.title+'</b>'+ cellRenderer(params) : cellRenderer(params);
		    }
		};

		SummaryRowRenderer.prototype.getGui = function() {
		    return this.eGui;
		};
		
		$scope.init=function(element,width,height){
			$scope.refreshWidget(null, 'init');
			$timeout(function(){
				$scope.widgetIsInit=true;
			},500);

		}
		
		$scope.reinit = function(){
			$scope.refreshWidget();
		}
		
		$scope.refresh = function(element,width,height, datasetRecords,nature) {
			$scope.showWidgetSpinner();
			
			if(datasetRecords){
				$scope.metadata = datasetRecords.metaData;
				$scope.totalRows = datasetRecords.results;
				if($scope.ngModel.style && $scope.ngModel.style.tr && $scope.ngModel.style.tr.height){
					_rowHeight = $scope.ngModel.style.tr.height;
					$scope.advancedTableGrid.api.resetRowHeights();
				}else delete _rowHeight;
				if($scope.ngModel.style && $scope.ngModel.style.th){
					if($scope.ngModel.style.th.enabled) $scope.advancedTableGrid.api.setHeaderHeight($scope.ngModel.style.th.height || 32);
					else $scope.advancedTableGrid.api.setHeaderHeight(0);
				}
				if(nature != 'sorting') $scope.advancedTableGrid.api.setColumnDefs(getColumns(datasetRecords.metaData.fields));
				if($scope.ngModel.settings.summary && $scope.ngModel.settings.summary.enabled) {
					$scope.advancedTableGrid.api.setRowData(datasetRecords.rows.slice(0,datasetRecords.rows.length-1));
					$scope.advancedTableGrid.api.setPinnedBottomRowData([datasetRecords.rows[datasetRecords.rows.length-1]]);
				}
				else {
					$scope.advancedTableGrid.api.setRowData(datasetRecords.rows);
					$scope.advancedTableGrid.api.setPinnedBottomRowData([]);
				}
				if($scope.ngModel.settings.pagination && $scope.ngModel.settings.pagination.enabled && !$scope.ngModel.settings.pagination.frontEnd){
					$scope.ngModel.settings.pagination.itemsNumber = $scope.ngModel.settings.pagination.itemsNumber || 15;
					$scope.totalPages = Math.ceil($scope.totalRows/$scope.ngModel.settings.pagination.itemsNumber) || 0;
				}
				if(!$scope.ngModel.settings.pagination.enabled) $scope.advancedTableGrid.api.paginationSetPageSize($scope.totalRows);
				if($scope.ngModel.settings.pagination.enabled && $scope.ngModel.settings.pagination.frontEnd && $scope.ngModel.settings.pagination.itemsNumber) $scope.advancedTableGrid.api.paginationSetPageSize($scope.ngModel.settings.pagination.itemsNumber);
				resizeColumns();
				$scope.hideWidgetSpinner();
			}
		}
		
		$scope.getOptions = function(){
			var obj = {};
				obj["page"] = $scope.ngModel.settings.page ? $scope.ngModel.settings.page - 1 : 0;
				obj["itemPerPage"] = ($scope.ngModel.settings.pagination && $scope.ngModel.settings.pagination.enabled && !$scope.ngModel.settings.pagination.frontEnd) ? $scope.ngModel.settings.pagination.itemsNumber : -1;
				obj["type"] = 'table';
			return obj;
		}
		
		$scope.advancedTableGrid = {
				angularCompileRows: true,
				onGridSizeChanged: resizeColumns,
				onGridReady: resizeColumns,
				onSortChanged: changeSorting,
				enableSorting: true,
				pagination : true,
				onCellClicked: onCellClicked,
				getRowHeight : function(params){
					if(_rowHeight > 0) return parseInt(_rowHeight);
					else return 28;
				}
		}
		function getRowHeight(params) {
			if(_rowHeight > 0) return _rowHeight;
			else return 28;
		}
		function changeSorting(){
			if($scope.ngModel.settings.pagination && $scope.ngModel.settings.pagination.enabled && !$scope.ngModel.settings.pagination.frontEnd){
				$scope.showWidgetSpinner()
				var sorting = $scope.advancedTableGrid.api.getSortModel();
				$scope.ngModel.settings.sortingColumn = sorting.length>0 ? getColumnName(sorting[0].colId) : '';
				$scope.ngModel.settings.sortingOrder = sorting.length>0 ? sorting[0]['sort'].toUpperCase() : '';
				$scope.refreshWidget(null, 'sorting');
			}
		}
		
		function resizeColumns(){
			$scope.advancedTableGrid.api.sizeColumnsToFit();
		}
		
	  	$scope.maxPageNumber = function(){
			if($scope.ngModel.settings.page * $scope.ngModel.settings.pagination.itemsNumber < $scope.totalRows) return $scope.ngModel.settings.page*$scope.ngModel.settings.pagination.itemsNumber;
			else return $scope.totalRows;
	  	}
	  	
	  	$scope.disableFirst = function(){
	  		return $scope.ngModel.settings.page == 1;
	  	}
	  	
	  	$scope.disableLast = function(){
	  		return $scope.ngModel.settings.page == $scope.totalPages;
	  	}
	  	
	  	$scope.first = function(){
	  		$scope.ngModel.settings.page = 1;
	  		$scope.refreshWidget();
		}
		
	  	$scope.prev = function(){
	  		if($scope.ngModel.settings.page == 1) return;
	  		$scope.ngModel.settings.page = $scope.ngModel.settings.page - 1;
	  		$scope.refreshWidget();
		}
		
	  	$scope.next = function(){
	  		$scope.ngModel.settings.page = $scope.ngModel.settings.page + 1;
	  		$scope.refreshWidget();
		}
		
	  	$scope.last = function(){
	  		$scope.ngModel.settings.page = $scope.totalPages;
	  		$scope.refreshWidget();
		}
		
		
		function onCellClicked(node){
			if(node.rowPinned) return;
			$scope.doSelection(node.column.colDef.headerName, node.value, $scope.ngModel.settings.modalSelectionColumn, null, node.data);
		}
		
		$scope.$watchCollection('ngModel.settings.pagination',function(newValue,oldValue){
			if(newValue != oldValue){
				$scope.showGrid = false;
				if(newValue && newValue.enabled && newValue.frontEnd){
					if(!newValue.itemsNumber) $scope.advancedTableGrid.paginationAutoPageSize = true;
					else $scope.advancedTableGrid.paginationAutoPageSize = false;
				}else if(newValue && !newValue.enabled){
					$scope.advancedTableGrid.paginationAutoPageSize = false;
					$scope.advancedTableGrid.paginationPageSize = angular.copy($scope.totalRows);
				}else {
					if(!newValue.itemsNumber) $scope.advancedTableGrid.paginationAutoPageSize = false;
					if(!newValue.itemsNumber) $scope.advancedTableGrid.paginationPageSize = 15;
				}
				$scope.showGrid = true;
				if(newValue && newValue.enabled != oldValue.enabled) $scope.refreshWidget();
			}
		})

		$scope.editWidget=function(index){
			var finishEdit=$q.defer();
			var config = {
					attachTo:  angular.element(document.body),
					controller: advancedTableWidgetEditControllerFunction,
					disableParentScroll: true,
					templateUrl: baseScriptPath+ '/directives/cockpit-widget/widget/advancedTableWidget/templates/advancedTableWidgetEditPropertyTemplate.html',
					position: $mdPanel.newPanelPosition().absolute().center(),
					fullscreen :true,
					hasBackdrop: true,
					clickOutsideToClose: false,
					escapeToClose: false,
					focusOnOpen: true,
					preserveScope: false,
					locals: {finishEdit:finishEdit,model:$scope.ngModel},
			};
			$mdPanel.open(config);
			return finishEdit.promise;
		}

	}

	/**
	 * register the widget in the cockpitModule_widgetConfigurator factory
	 */
	addWidgetFunctionality("advanced-table",{'initialDimension':{'width':5, 'height':5},'updateble':true,'cliccable':true});

})();