--��ѯĳ��Ա�������� ��н��ְλ

/*
1. ��ѯĳ��Ա����������Ϣ  --> out����̫��
2. ��ѯĳ������������Ա����������Ϣ  ---> ����
*/
create or replace procedure queryempinfo(eno in number,
                                                                         pename out varchar2,
                                                                         psal       out number,
                                                                         pjob      out varchar2)
as                                                                  
begin
  select ename,sal,empjob into pename,psal,pjob from emp where empno=eno;

end;
/