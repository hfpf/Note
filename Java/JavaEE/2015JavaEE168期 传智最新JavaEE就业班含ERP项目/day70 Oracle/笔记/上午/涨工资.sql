--�ǹ��ʣ��ܲ�1000 ����800 ����400
set serveroutput on

declare
  --Ա���ļ���
  --alter table "SCOTT"."EMP" rename column "JOB" to empjob
  cursor cemp is select empno,empjob from emp;
  pempno emp.empno%type;
  pjob       emp.empjob%type;
begin
  rollback;

  open cemp;

  loop
    --ȡһ��Ա��
    fetch cemp into pempno,pjob;
    exit when cemp%notfound;
    
    --�ж�ְλ
    if pjob = 'PRESIDENT' then update emp set sal=sal+1000 where empno=pempno;
      elsif pjob = 'MANAGER' then update emp set sal=sal+800 where empno=pempno;
      else update emp set sal=sal+400 where empno=pempno;
    end if;
  end loop;

  close cemp;
  
  --�ύ ----> ACID
  commit;
  
  dbms_output.put_line('���');
end;
/










