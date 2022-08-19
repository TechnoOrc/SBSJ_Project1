<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
	<head>
		<meta charset="UTF-8">
		<title> 주 문 서 </title>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
		<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
		<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
		
	</head>
	<body>
	<%@ include file="/WEB-INF/views/headerMain.jsp" %>
		<hr>
		<h3> 주 문 서 </h3>
		<hr>
		<table class="table table-hover">
			<col class="col-1">
			<thead>
				<tr>
				 <th> <input type="checkbox" id="cbx_chkAll" checked="checked">선택 </input> </th>
					<th> </th>	<th> 상품 </th>
						<th> 수량 </th>	
					<th> 가격 </th>
				</tr>
			</thead>
			<tbody>
				<c:set var="sum_md_class_qty" value="0" />
				<c:set var="sum_buy_amt" value="0" />
				<c:set var="sum_discount_amt" value="0" />
				<c:set var="delivery_cost" value="0" />
				<c:forEach var="dto" items="${list}" varStatus="status">
					<c:set var="sum_md_class_qty" value="${sum_md_class_qty + 1}" />
					<c:set var="sum_buy_amt" value="${sum_buy_amt + (dto.md_price * dto.buy_qty)}" />
					<c:set var="sum_discount_amt" value="${sum_discount_amt + ( (dto.md_price - dto.sale_price) * dto.buy_qty )}" />
					<tr>
					<td width="8%">
                                    <input type="checkbox" class="order_check_box form-control" checked="checked"
                                        id="${dto.md_price}" name="${dto.sale_price}" value="${dto.buy_qty}">
                                    <input type="hidden" id="cart_id${status.index}" name="cart_id${status.index}"
                                        value="${dto.cart_id}">
                                </td>
						<td width="10%">
							<img src="${dto.md_thumbnail_path}" class="img-thumbnail">
						</td>
						<td>
							<a href="${pageContext.request.contextPath}/md/detail?md_id=${dto.md_id}">
								${dto.md_name}
							</a>
						</td>
						<td width="15%">
                                    <div id="qty_btn">
                                        <button class="minus_btn">-</button>
                                        <input type="text" value="${dto.buy_qty}" class="quantity_input" readonly>
                                        <button class="plus_btn" data-max-qty="${dto.md_stock}">+</button>
                                    </div>
                                    <a class="qty_chg_btn" data-cart_id="${dto.cart_id}">변경</a>
                                <td width="30%"> ${dto.md_price * dto.buy_qty - ( (dto.md_price - dto.sale_price) *
                                    dto.buy_qty )} 원 </td>
                                    <button style = "display:none;" class="cart_delete_btn "  value="${dto.cart_id}"> 
                                    </button>
					</tr>
				</c:forEach>
				<c:choose>
					<c:when test = "${sum_buy_amt-sum_discount_amt >=30000 || sum_buy_amt-sum_discount_amt <= 0}"  >
						 <c:set var="delivery_cost" value="0"/> 
                    </c:when>
                    <c:otherwise>
                        <c:set var="delivery_cost" value="3000"/> 
                    </c:otherwise>
				</c:choose>	
				<td colspan="6">
                        <button id="delete_btn" class="btn btn-large btn-default"> 선택상품 삭제 </button>
                    </td>
			</tbody>
		</table>
		<hr>
		<div class="row">
			<div class="col-6">
				<table class="table table-hover table-borderless">
					<tr>
						<td>
							<a href="${pageContext.request.contextPath}/delivery/form">
								<button type="button" class="btn btn-primary btn-sm">
									배 송 지 추 가
								</button>
							</a>
							<button id="delivery_btn" type="button" class="btn btn-primary btn-sm"
							 		data-toggle="modal" data-target="#delivery_choice_modal">
								배 송 지 선 택
							</button>
						</td>
					</tr>
					<tr>
						<td id="td_delivery">
							<c:choose>
								<c:when test="${deliverylist != null && deliverylist[0] != null}">
									<div class="card">
										<div class="card-body">
											<h5 class="card-title">배송지 : ${deliverylist[0].addr_name}</h5>
											<p class="card-text">받는 분 : ${deliverylist[0].receiver} ( 연락처 : ${deliverylist[0].member_phone} )</p>
											<p class="card-text">( ${deliverylist[0].post_code} ) ${deliverylist[0].delivery_addr1} ${deliverylist[0].delivery_addr2}</p>
										</div>
									</div>
								</c:when>
								<c:otherwise>
									<h5> 등록된 배송지가 없습니다. </h5>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>
				</table>
				<input type="hidden" id="delivery_id" name="delivery_id"
					<c:if test="${deliverylist != null && deliverylist[0] != null}">
						value="${deliverylist[0].delivery_id}"
					</c:if>
				>
			</div>
			<div class="col-6">
				<table class="table table-hover">
					<tr>
						<th> 총 상품수 </th>
						<td class="text-right"> <span id="span_sum_md_class_qty">${sum_md_class_qty}</span> 개 </td>
					</tr>
					<tr>
						<th> 총 구 매 금 액 </th>
						<td class="text-right"> <span id="span_sum_buy_amt">${sum_buy_amt}</span> 원 </td>
					</tr>
					<tr>
						<th> 총 할 인 금 액 </th>
						<td class="text-right text-danger"> -<span id="span_sum_discount_amt">${sum_discount_amt}</span> 원 </td>
					</tr>
					<tr>
                        <th> 배송비 </th>
                        <td class="text-right">
                            <span class="text-right" id="span_delivery_cost">${delivery_cost}</span>원
                        </td>
                    </tr>
					<tr>
						<th> <h3>총 결 제 금 액</h3> </th>
						<td class="text-right"> <h3><span id="span_sum_total_buy_amt">${sum_buy_amt - sum_discount_amt+delivery_cost}</span> 원</h3> </td>
					</tr>
					<tr>
						<td colspan="2" class="text-center">
							<button id="order_btn" class="btn btn-danger btn-lg"> 결 제 하 기 </button>
							<button id="kakao_btn" class="btn btn-warning btn-lg"> 카카오페이 </button>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<hr>
<%-- 	<%@ include file="/WEB-INF/views/footer.jsp" %> --%>
	<!-- delivery modal start -->
	<div class="modal" id="delivery_choice_modal">
		<div class="modal-dialog">
			<div class="modal-content" >

				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title"> 배 송 지 선 택 </h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>

				<!-- Modal body -->
				<div class="modal-body">
					<table class="table table-hover table-borderless">
						<col class="col-10">
						<tbody>
							<c:forEach var="dto" items="${deliverylist}" varStatus="status">
								<tr>
									<td id="td_delivery${status.index}">
										<div class="card">
											<div class="card-body">
												<h5 class="card-title">배송지 : ${dto.addr_name}</h5>
												<p class="card-text">받는 분 : ${dto.receiver} ( 연락처 : ${dto.member_phone} )</p>
												<p class="card-text">( ${dto.post_code} ) ${dto.delivery_addr1} ${dto.delivery_addr2}</p>
											</div>
										</div>
									</td>
									<td class="text-right">
										<button class="addr_delete_btn btn btn-danger btn-sm mt-1 mb-1" value="${dto.delivery_id}"> 삭제 </button>
										<button class="addr_choice_btn btn btn-primary btn-sm" value="${dto.delivery_id}" name="${status.index}"data-dismiss="modal"> 선택 </button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

				<!-- Modal footer -->
				<div class="modal-footer">
					<a href="${pageContext.request.contextPath}/delivery/form">
						<button type="button" class="btn btn-primary btn-sm">
							배 송 지 추 가
						</button>
					</a>
					<button type="button" class="btn btn-warning btn-sm" data-dismiss="modal"> 취 소 </button>
				</div>

			</div>
		</div>
	</div>
	<!-- delivery modal end -->
 <script type="text/javascript">
                        $(document).ready(function () {
                            $(".plus_btn").click(function () {
                                let quantity = $(this).parent("div").find("input").val();
                                let maxQty = $(this).data("maxQty");
                                if (maxQty >= parseInt(quantity) + 1) {
                                    $(this).parent("div").find("input").val(++quantity);
                                }
                            });
                            $(".minus_btn").click(function () {
                                let quantity = $(this).parent("div").find("input").val();
                                if (1 < quantity) {
                                    $(this).parent("div").find("input").val(--quantity);
                                }
                            });
                            $(".qty_chg_btn").click(function () {
                                //alert( $(this).val() + " : " + $(this).prev().val() );
                                $.get(
                                    "${pageContext.request.contextPath}/cart/update_buy_qty"
                                    , {
                                        cart_id: $(this).data("cart_id")
                                        , buy_qty: $("#qty_btn").find("input").val()
                                    }
                                    , function (data, status) {
                                        if (data >= 1) {
                                            alert("구매 수량을 수정 하였습니다.");
                                            location.href = "${pageContext.request.contextPath}/order/order_list?arr_cart_id=" + arr_cart_id;

                                        } else {
                                            alert("구매 수량 수정을 실패 하였습니다.");
                                        }
                                    }//call back function
                                );//get

                            });//click
                        });//ready
                    </script>
                    <script type="text/javascript">
                        $(document).ready(function () {
                            $("#cbx_chkAll").click(function () {
                            	var $checkBoxList = $(".order_check_box");
                                   if ($("#cbx_chkAll").is(":checked")) {
                                   	   $(".order_check_box").prop("checked", true);
                                   	$("#span_sum_md_class_qty").text(${sum_md_class_qty});
                                        $("#span_sum_buy_amt").text(${sum_buy_amt});
                                        $("#span_sum_discount_amt").text(${sum_discount_amt});                                    
                                        $("#span_delivery_cost").text(${delivery_cost});
                                        $("#span_sum_total_buy_amt").text(${sum_buy_amt - sum_discount_amt+delivery_cost});
                                   } else {
                                   	   $(".order_check_box").prop("checked", false);
                                   		$("#span_sum_md_class_qty").text(0);
                                        $("#span_sum_buy_amt").text(0);
                                        $("#span_sum_discount_amt").text(0);
                                        $("#span_delivery_cost").text(0);
                                        $("#span_sum_total_buy_amt").text(0);
                                   }
                            });

                            $(".order_check_box").click(function () {
                                var total = $(".order_check_box").length;
                                var checked = $(".order_check_box:checked").length;

                                if (total != checked) $("#cbx_chkAll").prop("checked", false);
                                else $("#cbx_chkAll").prop("checked", true);
                            });
                        });
                    </script>
                    <script type="text/javascript">
                        $(document).ready(function () {
                            $(".order_check_box").click(function () {
                                //alert($(this).val() + " : " + $(this).attr("name") + " : " + $(this).attr("id"));

                                if ($(this).prop("checked") == true) {
                                    $("#span_sum_md_class_qty").text(
                                        parseInt($("#span_sum_md_class_qty").text()) + 1
                                    );
                                    $("#span_sum_buy_amt").text(
                                        parseInt($("#span_sum_buy_amt").text()) + ($(this).attr("id") * $(this).val())
                                    );
                                    $("#span_sum_discount_amt").text(
                                        parseInt($("#span_sum_discount_amt").text())
                                        + (($(this).attr("id") - $(this).attr("name")) * $(this).val())
                                    );
                                    $("#span_sum_total_buy_amt").text(
                                        parseInt($("#span_sum_total_buy_amt").text())
                                        + ($(this).attr("name") * $(this).val())
                                    );
                                    let totalAmt = parseInt($("#span_sum_total_buy_amt").text());
                                    let deliveryCost = totalAmt >= 30000 || totalAmt <= 0 ? 0 : 3000;
                                    $("#span_delivery_cost").text(deliveryCost);
                                } else if ($(this).prop("checked") == false) {
                                    $("#span_sum_md_class_qty").text(
                                        $("#span_sum_md_class_qty").text() - 1
                                    );
                                    $("#span_sum_buy_amt").text(
                                        $("#span_sum_buy_amt").text() - ($(this).attr("id") * $(this).val())
                                    );
                                    $("#span_sum_discount_amt").text(
                                        parseInt($("#span_sum_discount_amt").text())
                                        - (($(this).attr("id") - $(this).attr("name")) * $(this).val())
                                    );
                                    $("#span_sum_total_buy_amt").text(
                                        $("#span_sum_total_buy_amt").text()
                                        - ($(this).attr("name") * $(this).val())
                                    );
                                    let totalAmt = parseInt($("#span_sum_total_buy_amt").text());
                                    let deliveryCost = totalAmt >= 30000 || totalAmt <= 0 ? 0 : 3000;
                                    $("#span_delivery_cost").text(deliveryCost);
                                }//if

                            });//click
                        });//ready
                    </script>
					 <script type="text/javascript">
                        $(document).ready(function () {
                            $(".cart_delete_btn").click(function () {

                                $.get(
                                    "${pageContext.request.contextPath}/cart/delete"
                                    , {
                                        cart_id: $(this).val()
                                    }
                                    , function (data, status) {
                                        if (data >= 1) {
                                        	location.href = "${pageContext.request.contextPath}/order/order_list?arr_cart_id=" + arr_cart_id;
                                        } else {
                                            alert("상품 삭제를 실패 하였습니다.");
                                        }
                                    }//call back function
                                );//get

                            });//click
                            $("#delete_btn").click(function () {

                                let checks = $("input[type=checkbox]");
                                for (let i = 0; i < checks.length; i++) {
                                	if(i == 0) continue;
                                    if (checks[i].checked == true) {
                                    	 $(".cart_delete_btn")[i-1].click();
                                    }//if

                                }//for

                            });//click
                        });//ready
                    </script>
	<script type="text/javascript">
	let arr_cart_id = ${arr_cart_id};
	let str_cart_id = "";
	$.each( ${arr_cart_id}, function(idx, str) {
		//alert(idx + " : " + str);
		if(idx == 0){
			str_cart_id = str_cart_id + str;
		} else {
			str_cart_id = str_cart_id + "," + str;
		}
	});//each
	let buy_now_md_id = "${list[0].md_id}";
	let buy_now_qty = "${list[0].buy_qty}";
	</script>

	<script type="text/javascript">
	$(document).ready(function() {
		$(".addr_choice_btn").click(function() {

			$("#td_delivery").html( $("#td_delivery" + $(this).attr("name") ).html() );
			$("#delivery_id").val( $(this).val() );
// 			$("#delivery_choice_modal").modal("hide");

		});//click
	});//ready
	</script>

	<script type="text/javascript">
	$(document).ready(function() {
		$(".addr_delete_btn").click(function() {

			$.get(
					"${pageContext.request.contextPath}/delivery/delete"
					, {
						delivery_id : $(this).val()
					}
					, function(data, status) {
						if(data >= 1){
							alert("배송지 주소를 삭제 하였습니다.");
							location.href="${pageContext.request.contextPath}/order/order_list?arr_cart_id="+arr_cart_id;
						} else {
							alert("배송지 주소 삭제를 실패 하였습니다.");
						}
					}//call back function
			);//get

		});//click
	});//ready
	</script>

<!-- 일반 결제하기 -->
	<script type="text/javascript">
	$(document).ready(function () {
        let _delivery_id = $("#delivery_id").val();
		$("#order_btn").click(function() {
			$.post(
					"${pageContext.request.contextPath}/order/insert"
					, {
						delivery_id : $("#delivery_id").val()
						, order_md_cnt : $("#span_sum_md_class_qty").text()
						, order_amt : $("#span_sum_buy_amt").text()
						, discount_amt : $("#span_sum_discount_amt").text()
						, pay_amt : $("#span_sum_total_buy_amt").text()
						, str_cart_id : str_cart_id
						, buy_now_md_id : buy_now_md_id
						, buy_now_qty : buy_now_qty
					},
					function(data, status) {
						if(data >= 1){
							alert("주문을 성공적으로 등록 하였습니다.");
							location.href="${pageContext.request.contextPath}/order/list";
						} else if(data <= 0){
							alert("주문 등록을 실패 하였습니다.");
						} else {
							alert("잠시 후 다시 시도해 주세요.");
						}
					}//call back function
			);//post

		});//click
	}); //ready
	</script>

<!-- 카카오페이 -->
<script type="text/javascript">
	    $(document).ready(function(){$("#kakao_btn").click(function() {
	    	kakaoPay();
	     });
	    })
	    function kakaoPay() {
	        IMP.init('imp82628187');
	        
		    IMP.request_pay({
		    pg: "kakaopay"
		    ,pay_method: "card" //결제시 카드결제만 해야함. 카카오포인트로 결제 불가.
	        ,merchant_uid:'merchant_'+new Date().getTime() //상점에서 관리하는 주문 번호
	        ,name: "상품 이름 들어가는 곳" 			//'${dto.md_name}'이거 하면 "item_name can't be null." 에러가 뜸.
	        ,amount: '${sum_buy_amt - sum_discount_amt+delivery_cost}' //가격정보는 잘 뜸.
	        ,buyer_name:"구매자 이름"  			//'${dto.receiver}' 인식 안됨.
	        ,buyer_tel:"010-9999-9999" 		//'${dto.member_phone}' 인식 안됨.
	        }
	        , function(rsp) { //callback
	        	if (rsp.success) {
	                var msg = '결제가 완료 되었습니다.';
                    msg += ' 고유ID : ' + rsp.imp_uid;
                    msg += ' 상점 거래ID : ' + rsp.merchant_uid;
                    msg += ' 결제 금액 : ' + rsp.paid_amount;
                    msg += ' 카드 승인번호 : ' + rsp.apply_num;
                    msg += ' 구매자 이름 : ' + rsp.buyer_name;
                    msg += ' 구매자 전화번호 : ' + rsp.buyer_tel;
	            } else {
	            	var msg = '결제에 실패 하였습니다.';
                    msg += ' 에러내용 : ' + rsp.error_msg;
                    msg += ' 에러코드: ' + rsp.error_code;
	            }
	            alert(msg);
	        });
	    };
	</script>
	</body>
</html>
