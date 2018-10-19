/*
	HRPaySetupACH
	
	The HRPaySetupACH table contains identifying information about the receiving individual (or company). 
	It also contains the financial institution's routing number, receiver's account number 
	and deposit amount/percentage.					

*/

select 
	DistrictID,
	rtrim(DistrictAbbrev) as DistrictAbbrev,
	DistrictTitle
from tblDistrict

select 
	(select DistrictID from tblDistrict) as OrgId,
	te.EmployeeID as  EmpId,
	CONVERT(VARCHAR(10), dd.EffectiveDate, 110) as DateFrom,
	CONVERT(VARCHAR(10), dd.InactiveDate, 110) as DateThru,
	dd.RouteNum as BankRoutingNum,
	'D' as [Status],
	null as SeqNum,
	(case when isnull(dd.Amount,0) = 0 then 0 else dd.Amount end) as DepositAmt,
	(case when isnull(dd.Amount,0) = 0 then 1*100 else null end)as DepositPct,
	dd.AccountNum BankAcctNum,
	dt.[Description] BankAcctType,
	null as PrimaryPayCycleOnly,
	(case when isnull(dd.PayBalance,0) = 1 then 'TRUE' else 'FALSE' end) as PayBalance
from tblEmployee te
inner join
	DirectDeposit dd
	on te.EmployeeID = dd.ReferenceId
inner join
	DS_Global..DepositType dt
	on dt.Id = dd.ReferenceType

