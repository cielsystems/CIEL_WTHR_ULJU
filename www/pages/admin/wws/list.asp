<!--#include virtual="/common/common.asp"-->

<%
mnCD = "5001"
%>

<!--#include virtual="/common/header_adm.asp"-->

<div id="subPageBox">
	
	<div class="listSchBox">
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
					<table align="left">
						<tr>
							<td><label>종류</label></td>
							<td>
								<select>
									<option value="">::: 전체 :::</option>
									<option value="">한파</option>
									<option value="">대설</option>
								</select>
							</td>
							<td width="20px"></td>
							<td><label>단계</label></td>
							<td>
								<select>
									<option value="">::: 전체 :::</option>
									<option value="">주의보</option>
								</select>
							</td>
							<td width="20px"></td>
							<td><label>검색</label></td>
							<td>
								<input type="text" id="schVal" name="schVal" onkeypress="if(event.keyCode==13){fnLoadPage(1)}" />
							</td>
							<td><img class="imgBtn" src="<%=pth_pubImg%>/btn/green_sch2.png" title="검색" onclick="fnLoadPage(1)" /></td>
						</tr>
					</table>
					
				</td>
				<td class="aR" width="180px">
					총 <b><span id="cntAll">0</span></b>건
					<img class="imgBtn" src="<%=pth_pubImg%>/btn/blue_add2.png" onclick="fnNotiForm(0)" />
				</td>
			</tr>
		</table>
	</div>
	
	<table border="0" cellpadding="0" cellspacing="1" class="tblList">
		<colgroup>
			<col width="100px" />
			<col width="100px" />
			<col width="100px" />
			<col width="*" />
			<col width="180px" />
			<col width="160px" />
			<col width="80px" />
		</colgroup>
		<tr>
			<th>종류</th>
			<th>단계</th>
			<th>코드</th>
			<th>제목</th>
			<th>통보시각</th>
			<th>전송방법</th>
			<th>관리</th>
		</tr>
		<tr>
			<td class="aC">한파</td>
			<td class="aC">주의보</td>
			<td class="aC">발표</td>
			<td class="aL">한파주의보발표알림1</td>
			<td class="aC">검사시각 <span class="color_blue">즉시</span></td>
			<td class="aC">음성+문자</td>
			<td class="aC"><button class="btn btn_sm bg_olive">관리</button></td>
		</tr>
		<tr>
			<td class="aC">대설</td>
			<td class="aC">주의보</td>
			<td class="aC">발표</td>
			<td class="aL">대설주의보발표알림1</td>
			<td class="aC">검사시각 <span class="color_red">예약 10분후</span></td>
			<td class="aC">음성+문자</td>
			<td class="aC"><button class="btn btn_sm bg_olive">관리</button></td>
		</tr>
	</table>
	
</div>

<!--#include virtual="/common/footer_adm.asp"-->

<script type="text/javascript">
	
	function fnNotiForm(indx){
		layerW = 1000;
		layerH = 600;
		fnOpenLayer('통보관리', 'pop_notiForm.asp?notiIndx='+indx);
	}
	
</script>