program Create_Long_File_Names;  {12/25/88}
                                 {revised 11/25/89}

(* This is a demo of a technique for writing lengthy file names which are
   correlated with randomly generated 8-character filespecs *)

type
   Matrix      = array[1..50,1..2] of string[20];


var
   a,b,c,d,e,f,g,h : integer;
   j,k,n           : integer;
   NameFlag        : integer;
   code            : string[8];
   FileSpec        : string[20];
   FileName        : string[20];
   MatrixFile      : file of Matrix;
   NameMatrix      : Matrix;
   Name            : file of real;
   ch              : char;
   x,y             : real;


procedure GetDataFile;
begin
     clrscr;
     j:=1;
     ch:=' ';
     NameFlag:=0;
     reset(MatrixFile);
     if n >= 0 then begin
          writeln('The following files have been created:');
          writeln;
          writeln('           FileName              FileSpec');
          writeln;
          while not eof(MatrixFile) do begin
              read(MatrixFile,NameMatrix);
              writeln(NameMatrix[j,1]:20, '     =      ',NameMatrix[j,2]);
              j:=j + 1;
          end;
          close(MatrixFile);
          writeln;
          writeln('Enter the file name for which you wish to read the sample data file');
          writeln('   or else simply hit Enter to by-pass this procedure');
          writeln;
          readln(FileName);
          if FileName <>''then begin
             writeln;
             j:=1;
             reset(MatrixFile);
             while not eof(MatrixFile) do begin
                   read(MatrixFile,NameMatrix);
                   if NameMatrix[j,1] = FileName then begin
                      NameFlag:=1;
                      assign(Name,NameMatrix[j,2]);
                      {$I-} reset(Name);{$I+}
                      If IOresult <> 0 then begin
                         clrscr;
                         writeln('File does not exist');
                         halt;
                      end;
                   end;
                   j:=j + 1;
             end;
             if NameFlag = 0 then begin
                  writeln('You have incorrectly entered a file name');
                  writeln('  Re-run code');
                  halt;
             end;
             close(MatrixFile);
             writeln('Data for ',FileName,' :');
             writeln;

(*********************** Read sample data file *******************************)
                      k:=1;
                      while not eof(Name) do begin
                            read(Name,x,y);
                            writeln('"x"[',k,'] = ',x,'    "y"[',k,'] = ',y);
                            k:=k + 1;
                      end;
                      close(Name);

(*********************** Close sample data file ******************************)
             if NameFlag = 0 then begin
                writeln('File name has not been created; re-run');
                halt;
             end;
          end;
     end;
end;

procedure Quit;
begin
      clrscr;
      j:=1;
      reset(MatrixFile);
      writeln('The following files have been created:');
      writeln;
      writeln('           FileName              FileSpec');
      writeln;
      while not eof(MatrixFile) do begin
          read(MatrixFile,NameMatrix);
          writeln(NameMatrix[j,1]:20, '     =      ',NameMatrix[j,2]);
          j:=j + 1;
      end;
      writeln;
      close(MatrixFile);
      halt;
end;

procedure Intro;
begin

writeln('This code demonstrates a technique for using long (e.g., > 8 characters)');
writeln('file names.  The code, written in Turbo Pascal 3.1, sets up a two column');
writeln('matrix of strings, the first column containing the long file name, and the');
writeln('second column containing an 8-character file spec with the extension, ".dat".');
writeln('The file spec for each name is generated by a random scramble of characters.');
writeln('When the long file name is called, a file containing containing the matrix');
writeln('is searched for the file spec matching the file name.  That file spec is');
writeln('then opened for input or output.  This demo is inteneded as a very simple');
writeln('example of the technique.');
writeln;

end;

begin      {MAIN PROGRAM}

     ch:=' ';
     j:=1;
     clrscr;
     Intro;
     assign(MatrixFile,'names.dat');
     {$I-} reset(MatrixFile);{$I+}
     if IOresult <> 0 then begin
        rewrite(MatrixFile);
     end
     else begin
          reset(MatrixFile);
          n:=FileSize(MatrixFile);
          if n = 0 then writeln('There are no existing data files')
          else begin
               writeln;
               writeln('Enter "r" if you wish to read any existing data file;');
               writeln('    else hit Enter');
               read(kbd,ch);
               if ch = 'r' then GetDataFile;
               writeln;
          end;
     end;
     while j <= 50 do begin   {50 is arbitrary}
         writeln;
         writeln('Enter a new filename...up to 20 characters including spaces. ');
         writeln('   Or hit Enter to quit program.');
         readln(FileName);
         reset(MatrixFile);
         seek(MatrixFile, FileSize(MatrixFile));
         if (FileName = ' ') or (FileName = '') then begin
            clrscr;
            halt;
         end;
         a:= random(26) + 65 ; b:= random(26) + 65 ; c:= random(26) + 65 ;
         d:= random(26) + 65 ; e:= random(26) + 65 ; f:= random(26) + 65 ;
         g:= random(26) + 65 ; h:= random(26) + 65;
         Code := chr(a) + chr(b) + chr(c) + chr(d) + chr(e) + chr(f)
                    + chr(g) + chr(h);
         FileSpec:=Code +'.dat';
         NameMatrix[j,1]:=FileName;
         NameMatrix[j,2]:=FileSpec;
         write(MatrixFile,NameMatrix);
         writeln;
         writeln('The fileSpec for ',FileName,' is ',FileSpec);
         writeln;
         ch:=' ';
         assign(Name,FileSpec);
         rewrite(Name);

(*********************** Input sample data file ******************************)
         k:=1;
         writeln('Entering sample data for ',FileName);
         writeln;
         repeat
               write('Enter value of "x"[',k,'] :  ');
               readln(x);
               write('Enter value of "y"[',k,'] :  ');
               readln(y);
               write(Name,x,y);
               k:=k + 1;
               writeln;
               writeln('Enter "q" to quit data input');
               read(kbd,ch);
               writeln;
         until ch = 'q';
         if ch = 'q' then close(Name);

(*********************** Close sample data file ******************************)

         j:=j + 1;
    end;
    close(MatrixFile);
end.

