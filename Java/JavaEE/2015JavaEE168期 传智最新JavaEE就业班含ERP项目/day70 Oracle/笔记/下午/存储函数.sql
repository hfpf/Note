--��ѯĳ��Ա����������
create or replace function queryempincome(eno in number)
return number
as
  --��н�ͽ���
  psal emp.sal%type;
  pcomm emp.comm%type;
begin
  select sal,comm into psal,pcomm from emp where empno=eno;

  --����������
  return psal*12+nvl(pcomm,0);
end;
/