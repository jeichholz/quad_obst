function [node elem surf] = read_mesh(fname)
%[node elem] = meshread(filename)
%function to read .mesh file from the 'fname'
%
%Copyright (C) 2010 Todd C. Doehring. See COPYRIGHT.TXT for details.

node=[];
elem=[];
surf=[];
fid=fopen(fname,'rt');

for i = 1:3; line=fgetl(fid);end
dim=fscanf(fid,'%d',1);
node=fscanf(fid,'%f',[4,dim])';

line=fgetl(fid);
line=fgetl(fid);
dim=fscanf(fid,'%d',1);
surf=fscanf(fid,'%u',[4,dim])';

line=fgetl(fid);
line=fgetl(fid);
dim=fscanf(fid,'%d',1);
elem=fscanf(fid,'%u',[5,dim])';

elem=elem(:,1:4);
surf=surf(:,1:3);
node=node(:,1:3);
fclose(fid);
