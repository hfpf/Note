--��ѯ����ӡԱ����������нˮ
/*
1.  ��������
      %isopen      %rowcount (Ӱ�������)
      %found       %notfound

*/
set serveroutput on
declare
  -- ������
  cursor cemp is select ename,sal from emp;
  pename emp.ename%type;
  psal       emp.sal%type;
begin
  --�򿪹��
  open cemp;
  
  loop
    --ȡһ����¼
    fetch cemp into pename,psal;
    --exit when û��ȡ����¼;
    exit when cemp%notfound;

    dbms_output.put_line(pename||'��нˮ��'||psal);

  end loop;
  
  --�رչ��
  close cemp;
end;
/