--查询某个员工的姓名 月薪和职位

/*
1. 查询某个员工的所有信息  --> out参数太多
2. 查询某个部门中所有员工的所有信息  ---> 集合
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