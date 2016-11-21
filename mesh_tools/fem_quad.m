function [omegas,wieghts,A,B,Conn_mat]=fem_quad(nphi,ntheta,doplot)

global omega_struct;

if isempty(omega_struct)||~exist('omega_struct')
    fprintf('omega_struct is empty. Loading and making global for future use\n');
    load 'omega_struct'
end
doupdate=0;
for field=fieldnames(omega_struct)'
    if nphi>size(omega_struct,1)||ntheta>size(omega_struct,2)||isempty(getfield(omega_struct(nphi,ntheta),field{:}))
        doupdate=1;
        break;
    end
end
if ~doupdate
    omegas=omega_struct(nphi,ntheta).omegas;
    wieghts=omega_struct(nphi,ntheta).weights;
    A=omega_struct(nphi,ntheta).A;
    B=omega_struct(nphi,ntheta).B;
    PPtSP=omega_struct(nphi,ntheta).PPtSP;
    SPtPP=omega_struct(nphi,ntheta).SPtPP;
    PN=omega_struct(nphi,ntheta).PN;
    CI=omega_struct(nphi,ntheta).CI;
else
    fprintf('Have not seen this nphi/nomega. Generating and saving.\n');
    [PN,C1,CI,IM]=make_mesh(nphi,ntheta);
    [SPtPP,PPtSP]=get_ConversionMaps(CI,IM);
    nomega=length(unique(CI));
    [oX,oY,oZ]=sphere2cart(PN(SPtPP,1),PN(SPtPP,2));
    omegas=[oX,oY,oZ];
    C=C1;
    NtoE=get_NtoE(CI);
    NtoN=get_NtoN(CI,NtoE);
    NtoLN=get_NtoLN(CI,NtoE);
    areas=get_areas(PN,C);
    for i = 1:length(C)
        IK(i,:,:)=get_IoverK(C,PN,i,areas);
        GIK(i,:,:)=get_GIoverK(C,PN,i,areas); 
    end
    [A,B,Khits]=make_mass_1(PN,CI,NtoE,NtoN,NtoLN,IK,GIK,IM);
    wieghts=A*ones(size(A,1),1);
    weights=wieghts;
    for field= fieldnames(omega_struct)'
        eval(['omega_struct(' num2str(nphi) ',' num2str(ntheta) ').' field{:} '=' field{:} ';']);
    end
end
Conn_mat=PPtSP(CI);

if exist('doplot') && (doplot==1)
     [oX,oY,oZ]=sphere2cart(PN(SPtPP,1),PN(SPtPP,2));
    trimesh(PPtSP(CI),oX,oY,oZ,1*ones(size(oX)));
end