--��ѯ����ӡ7839��������нˮ
set serveroutput on

declare
  --�����������������нˮ
  --pename varchar(20);
  --psal       number;
  pename emp.ename%type;
  psal        emp.sal%type;
begin
  --�õ�������нˮ
  select ename,sal into pename,psal from emp where empno=7839;
  dbms_output.put_line(pename||'��нˮ��'||psal);
end;
/