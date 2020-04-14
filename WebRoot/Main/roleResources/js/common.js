//common functions

		$( document ).ready(function() {
			 let activeTab = $(".tab-content").find(".tab-pane.active");
	         let idActiveTab = activeTab.attr('id');
	         reloadDatatable(idActiveTab);
		});

      function deleteAddRow(current) {
          $(current).parents('tr').remove();
      }

      function reloadDatatable(activeTab) {
          $("#loader").addClass("active");
          if (activeTab == "inventory-md") {
        	  loadInventoryTable();
          } else if (activeTab == "requisition-md") {
        	  loadRequisitionTable();
          } else if (activeTab == "purchaseorder-md") {
              loadVendorMasterTable();
          }
      }


      function activateLabels() {
          // Get a NodeList of all .demo elements
          const labels = document.querySelectorAll('label');
          // Change the text of multiple elements with a loop
          labels.forEach(element => {
              element.classList.add('active');
          });
      }

      function deactivateLabels() {
          // Get a NodeList of all .demo elements
          const labels = document.querySelectorAll('label');
          // Change the text of multiple elements with a loop
          labels.forEach(element => {
              element.classList.remove('active');
          });
      }

      function clearInputFieldsModal() {
          $('.row').find('input').val('');
          $('.row').find('select').prop('selectedIndex', 0);
          $('.row').find('.select2').val("").trigger("change");
      }

      function formateDate(date) {
          if (date == null) {
              return "";
          }
          date = new Date(date);
          return date.getDate() + "-" + ("0" + (date.getMonth() + 1)).slice(-2) + "-" + date.getFullYear();
      }

      function formatDateForEdit(date) {
          if (date == null) {
              return "";
          }
          date = new Date(date);
          return date.getFullYear() + "-" +
              ("0" + (date.getMonth() + 1)).slice(-2) + "-" +
              date.getDate();
      }

      function activateDeactivate(type, id, apiName) {
          let url = '';
          if (apiName == "customer") {
              url = baseUrl+'8093/';

          } else if (apiName == "asset") {
              url = baseUrl+'8092/';
          } else {
              url = baseUrl+'8091/';
          }

          $.ajax({
              url: url + type + '/' + apiName + '/' + id,
              method: 'PUT',
              contentType: "application/json",
              success: function(result) {
                  (type == "activate") ? sweetAlert("Record activated successfully!"): sweetAlert("Record deactivated successfully!");
                  let activeTab = $(".tab-content").find(".tab-pane.active");
                  let idActiveTab = activeTab.attr('id');
                  reloadDatatbleAfterImport(idActiveTab);

              }
          })
      }
      
     	function loadBranches(dropDownName) {
			$.ajax({
				url : baseUrl+'8091/branch',
				success : function(response) {
					list = response.responseBody;
					$("#" + dropDownName).empty().select2();
					
					$('#'+dropDownName).append(
							$("<option></option>").attr("value", 0).text(
									"Select Branch"));
					for (var i = 0; i < list.length; i++) {
						$('#'+dropDownName).append(
								$("<option></option>")
										.attr("value", list[i].id).text(
												list[i].companyName));
					}
					$("#" + dropDownName).select2();
					
				}
			});
		}
     	
     	function loadBranchesParent(dropDownName, parentName) {
			$.ajax({
				url : baseUrl+'8091/branch',
				success : function(response) {
					list = response.responseBody;
					$("#" + dropDownName).empty().select2();
					
					$('#'+dropDownName).append(
							$("<option></option>").attr("value", 0).text(
									"Select Branch"));
					for (var i = 0; i < list.length; i++) {
						$('#'+dropDownName).append(
								$("<option></option>")
										.attr("value", list[i].id).text(
												list[i].companyName));
					}
					$("#" + dropDownName).select2({
						dropdownParent : $("#" + parentName)
					})
					
				}
			});
		}
     	
		function loadPartsByPartName(dropDownName, parentName, partName) {

			$
					.ajax({
						url : baseUrl + '8091/part/byName/' + partName,
						success : function(response) {
							list = response.responseBody;
							$("#" + dropDownName).empty().select2();
							$('#' + dropDownName).append(
									$("<option></option>").attr("value", 0)
											.text("Select Part Number"));
							for (var i = 0; i < list.length; i++) {
								$('#' + dropDownName)
										.append(
												$("<option></option>")
														.attr(
																"data-partcategory",
																list[i].partCategoryEntity.spareCategoryName)
														.attr(
																"data-parttype",
																list[i].partCategoryEntity.spareCategoryName)
														.attr(
																"data-partdescription",
																list[i].description)
														.attr("value",
																list[i].id)
														.text(list[i].partNo));
							}
							$("#" + dropDownName).select2({
								dropdownParent : $("#" + parentName)
							})

						}
					});
		}	
	function loadUniquePartName(dropDownName, parentName) {

		$.ajax({
			url : baseUrl + '8091/part/getPartNames',
			success : function(response) {
				list = response.responseBody;
				$("#" + dropDownName).empty().select2();

				$('#' + dropDownName).append(
						$("<option></option>").attr("value", 0).text(
								"Select Part Name"));
				for (var i = 0; i < list.length; i++) {
					$('#' + dropDownName).append(
							$("<option></option>").attr("value", list[i])
									.text(list[i]));
				}
				$("#" + dropDownName).select2({
					dropdownParent : $("#" + parentName)
				})

			}
		});
	}
	function loadManufacturers(dropDownName, parentName, partNo) {
		$.ajax({ url : baseUrl + '8091/manufacturers/bypartId/' + partNo,
			  success : function(response) {
				list = response;
				$("#" + dropDownName).empty().select2();
		
				$('#' + dropDownName).append(
						$("<option></option>").attr("value", 0).text(
								"Select Manufacturer Name"));
				for (var i = 0; i < list.length; i++) {
					$('#' + dropDownName).append(
							$("<option></option>")
									.attr("value", list[i].id).text(
											list[i].name));
				}
				$("#" + dropDownName).select2({
					dropdownParent : $("#" + parentName)
				})
			  } 
			  });
	}

	
	

	function loadVendors(dropDownName, parentName, partNo) {
		$.ajax({
			url : baseUrl + '8091/vendors/bypartId/' + partNo,
			success : function(response) {
				list = response;
				$("#" + dropDownName).empty().select2();

				$('#' + dropDownName).append(
						$("<option></option>").attr("value", 0).text(
								"Select Vendor Name"));
				for (var i = 0; i < list.length; i++) {
					$('#' + dropDownName).append(
							$("<option></option>")
									.attr("value", list[i].id).text(
											list[i].name));
				}
				$("#" + dropDownName).select2({
					dropdownParent : $("#" + parentName)
				})

			}
		});
	}

     	
     	
     	
     	function loadModels(dropDownName, parentName, partNo) {
     		// url : baseUrl+'8091/manufacturers/bypartId/' + partNo,
			
			$.ajax({
				url : baseUrl+'8091/branch',
				success : function(response) {
					list = response.responseBody;
					list = [
						    {
						        "id": 342,
						        "name": "Honda"
						    }
						]
					$("#" + dropDownName).empty().select2();
					
					$('#'+dropDownName).append(
							$("<option></option>").attr("value", 0).text(
									"Select Part Name"));
					for (var i = 0; i < list.length; i++) {
						$('#'+dropDownName).append(
								$("<option></option>")
										.attr("value", list[i].id).text(
												list[i].name));
					}
					$("#" + dropDownName).select2({
						dropdownParent : $("#" + parentName)
					})
									
				}
			});
		}
     	
     	
		
     	
     	function generatePDF(id)
     	{
     		var doc = new jsPDF();

     	    doc.setFontSize(18);
     	    doc.text('With content', 14, 22);
     	    doc.setFontSize(11);
     	    doc.setTextColor(100);
     	    
     	    // jsPDF 1.4+ uses getWidth, <1.4 uses .width
     	    var pageSize = doc.internal.pageSize;
     	    var pageWidth = pageSize.width ? pageSize.width : pageSize.getWidth();
     	    var text = doc.splitTextToSize(faker.lorem.sentence(45), pageWidth - 35, {});
     	    doc.text(text, 14, 30);

     	    doc.autoTable({
     	        head: headRows(),
     	        body: bodyRows(40),
     	        startY: 50, 
     	        showHead: 'firstPage'
     	    });

     	    doc.text(text, 14, doc.autoTable.previous.finalY + 10);

     	    return doc;
     		doc.save('a4.pdf')
     	}
     	
		function makeEditable(current, colNum) {
			var currentTD = $(current).parents('tr').find('td');
			if ($(current).hasClass("fa-pencil-alt")) {
				$(current).removeClass("fa-pencil-alt");
				$(current).addClass("fa-save");
				let x = 0;
				$.each(currentTD, function() {
					if (x == colNum) {
						$(this).prop('contenteditable', true)
						$(this).addClass('greenBorder')
					}
					x++;
				});
			} else {
				$(current).addClass("fa-pencil-alt");
				$(current).removeClass("fa-save");
				let x = 0;
				$.each(currentTD, function() {
					if (x == colNum) {
						$(this).prop('contenteditable', false)
						$(this).removeClass('greenBorder')
						$(this).html(
								$(currentTD[colNum]).html().split("<br>").join(""))                       

					}
					x++;
				});

			}

		}