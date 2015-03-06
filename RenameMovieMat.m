function [ output_args ] = RenameMovieMat(matfile,desiredbase,dataclass)

temp = load(matfile);
Index = temp.Index;
Object = temp.Object;

Index.ObjFile = [desiredbase,'.mat'];
Index.H5File = [desiredbase,'.h5'];
Index.DataClass = dataclass;

save([desiredbase,'.mat'],'Index','Object');


end

