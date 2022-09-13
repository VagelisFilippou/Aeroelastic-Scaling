function [BAR,BEAM]=Beam_Bar_Elements
file='ucrm.h5';
h5data=h5extract(file);

Beam(1,:)=h5data.NASTRAN.INPUT.ELEMENT.CBEAM.GA;
Beam(2,:)=h5data.NASTRAN.INPUT.ELEMENT.CBEAM.GB;

Bar(1,:)=h5data.NASTRAN.INPUT.ELEMENT.CBAR.GA;
Bar(2,:)=h5data.NASTRAN.INPUT.ELEMENT.CBAR.GB;

Beam=transpose(Beam);
Bar=transpose(Bar);

BarA=transpose(h5data.NASTRAN.INPUT.NODE.GRID.X(:,h5data.NASTRAN.INPUT.ELEMENT.CBAR.GA));
BarB=transpose(h5data.NASTRAN.INPUT.NODE.GRID.X(:,h5data.NASTRAN.INPUT.ELEMENT.CBAR.GB));

BeamA=transpose(h5data.NASTRAN.INPUT.NODE.GRID.X(:,h5data.NASTRAN.INPUT.ELEMENT.CBEAM.GA));
BeamB=transpose(h5data.NASTRAN.INPUT.NODE.GRID.X(:,h5data.NASTRAN.INPUT.ELEMENT.CBEAM.GB));


for i=1:length(Bar(:,1))
    BAR{i}=[BarA(i,:);BarB(i,:)];
end
for i=1:length(Beam(:,1))
    BEAM{i}=[BeamA(i,:);BeamB(i,:)];
end
   

    
