%Justin Gerolami
%Last updated 10/18/19


% Notice: 
%   This file is provided by Verasonics to end users as a programming
%   example for the Verasonics Vantage Research Ultrasound System.
%   Verasonics makes no claims as to the functionality or intended
%   application of this program and the user assumes all responsibility 
%   for its use
%
% File name: MultiFocalPoint.m - 
%                                 
% Description: 
%   Sequence programming file for L11-4v linear array using 128 ray lines
%   (focused transmits) and receive acquisitions. Of the 128 transmit channels,
%   only numTx are used, with numTx/2 transmitters on each side of the center 
%   element (where possible). All 128 receive channels are active for each 
%   acquisition. 
% 
%
%   This code will collect a time series of ultrasound (TeUS) for a set number of frames.
%   In each frame, the focal point is shifted based on pre-defined parameters. 
%   This is saved in SWIOutput as a 3d matrix.


clear all

%Used for calculating time between acquisitons
FR = 50; % in frames per second
acqTime = 4;% in seconds 

acqFrames = acqTime * FR; % number of frames in the receive buffer
pulsePeriod = 1e6 / FR; % inVSX usec

%Stores the IQ time series data
SWIOutput = struct([]);
%RFOutput = struct([]);
nFr = 1;


%Presets
P.startDepth = 0;
P.endDepth = 128;
P.initialFocus = 61;  % Initial transmit focus. 41=10, 61=15
P.numTx = 32;  % number of transmit elements in TX aperture (where possible).


%Used for calculation of multiple focal points
numberOfCycles = 4;
focalAmplitude = 6; %amplitude in wavelengths
ZFocal = zeros(1,acqFrames);

for i = 1:acqFrames
    ZFocal(i) = P.initialFocus + focalAmplitude * sin(2*pi*(i-1)*numberOfCycles/acqFrames);
    %ZFocal(i) = P.initialFocus + focalAmplitude * sawtooth(2*pi*(i-1)*numberOfCycles / acqFrames,0.5);
end



% Define system parameters.
Resource.Parameters.numTransmit = 128;      % number of transmit channels.
Resource.Parameters.numRcvChannels = 128;    % number of receive channels.
Resource.Parameters.speedOfSound = 1540;    % set speed of sound in m/sec before calling computeTrans
Resource.Parameters.verbose = 2;
Resource.Parameters.initializeOnly = 0;
Resource.Parameters.simulateMode = 0;
%  Resource.Parameters.simulateMode = 1 forces simulate mode, even if hardware is present.
%  Resource.Parameters.simulateMode = 2 stops sequence and processes RcvData continuously.


% Specify Trans structure array.
Trans.name = 'L11-4v';
Trans.units = 'wavelengths'; % Explicit declaration avoids warning message when selected by default
Trans = computeTrans(Trans);  % L11-4v transducer is 'known' transducer so we can use computeTrans.
% note nominal center frequency from computeTrans is 6.25 MHz
Trans.maxHighVoltage = 50;  % set maximum high voltage limit for pulser supply.


% Specify PData structure array.
PData(1).PDelta = [Trans.spacing, 0, 0.25];  % x, y, z pdeltas
PData(1).Size(1) = ceil((P.endDepth-P.startDepth)/PData(1).PDelta(3));
PData(1).Size(2) = ceil((Trans.numelements*Trans.spacing)/PData(1).PDelta(1));
PData(1).Size(3) = 1;      % single image page
PData(1).Origin = [-Trans.spacing*(Trans.numelements-1)/2,0,P.startDepth]; % x,y,z of upper lft crnr


% - specify 128 Region structures.
PData(1).Region = repmat(struct('Shape',struct( ...
                    'Name','Rectangle',...
                    'Position',[0,0,P.startDepth],...
                    'width',Trans.spacing,...
                    'height',P.endDepth-P.startDepth)),1,128);
% - set position of regions to correspond to beam spacing.
for i = 1:128
    PData(1).Region(i).Shape.Position(1) = (-63.5 + (i-1))*Trans.spacing;
end
PData(1).Region = computeRegions(PData(1));


% Specify Media object.
pt1;
Media.attenuation = -0.5;
Media.function = 'movePoints';


% Specify Resources.
Resource.RcvBuffer(1).datatype = 'int16';
Resource.RcvBuffer(1).rowsPerFrame = 2048*128;   % this size allows for maximum range
Resource.RcvBuffer(1).colsPerFrame = Resource.Parameters.numRcvChannels;
Resource.RcvBuffer(1).numFrames = 40;       % 20 frames used for RF cineloop.


Resource.InterBuffer(1).numFrames = 1;  % one intermediate buffer needed.
Resource.ImageBuffer(1).numFrames = 10;
Resource.DisplayWindow(1).Title = 'L11-4v_128RyLns';
Resource.DisplayWindow(1).pdelta = 0.35;
ScrnSize = get(0,'ScreenSize');
DwWidth = ceil(PData(1).Size(2)*PData(1).PDelta(1)/Resource.DisplayWindow(1).pdelta);
DwHeight = ceil(PData(1).Size(1)*PData(1).PDelta(3)/Resource.DisplayWindow(1).pdelta);
Resource.DisplayWindow(1).Position = [250,(ScrnSize(4)-(DwHeight+150))/2, ...  % lower left corner position
                                      DwWidth, DwHeight];
Resource.DisplayWindow(1).ReferencePt = [PData(1).Origin(1),0,PData(1).Origin(3)];   % 2D imaging is in the X,Z plane
Resource.DisplayWindow(1).numFrames = 20;
Resource.DisplayWindow(1).AxesUnits = 'mm';
Resource.DisplayWindow.Colormap = gray(256);


% Specify TW structure array.
TW(1).type = 'parametric';
TW(1).Parameters = [Trans.frequency,0.67,2,1];


% Specify nr TX structure arrays. Transmit centered on element n in the array for event n.
TX = repmat(struct('waveform', 1, ...
                   'Origin', [0.0,0.0,0.0], ...
                   'focus', P.initialFocus, ...
                   'Steer', [0.0,0.0], ...
                   'Apod', zeros(1,Trans.numelements), ...
                   'Delay', zeros(1,Trans.numelements)), 1, 128*acqFrames);        
				   
% - Set event specific TX attributes.

for m = 1:acqFrames
    focusToUse = ZFocal(m);
    
    for n = 1:128  % 128 transmit events
        loc = (128*(m-1))+n;
        % Set transmit Origins to positions of elements.
        TX(loc).Origin = [(-63.5 + (n-1))*Trans.spacing, 0.0, 0.0];
        % Set transmit Apodization.
        lft = n - floor(P.numTx/2);
        if lft < 1, lft = 1; end
        rt = n + floor(P.numTx/2);
        if rt > Trans.numelements, rt = Trans.numelements; end
        TX(loc).focus = focusToUse;
        TX(loc).Apod(lft:rt) = 1.0;
        TX(loc).Delay = computeTXDelays(TX(loc));
    end
end


% Specify Receive structure arrays. 
% - We need 128 Receives for every frame.
maxAcqLength = ceil(sqrt(P.endDepth^2 + ((Trans.numelements-1)*Trans.spacing)^2));
Receive = repmat(struct('Apod', ones(1,Trans.numelements), ...
                        'startDepth', P.startDepth, ...
                        'endDepth', maxAcqLength, ...
                        'TGC', 1, ...
                        'bufnum', 1, ...
                        'framenum', 1, ...
                        'acqNum', 1, ...
                        'sampleMode', 'NS200BW',...
                        'mode', 0, ...
                        'callMediaFunc', 0), 1, 128*Resource.RcvBuffer(1).numFrames);
% - Set event specific Receive attributes.
for i = 1:Resource.RcvBuffer(1).numFrames
    k = 128*(i-1);
    Receive(k+1).callMediaFunc = 1;
    for j = 1:128
        Receive(k+j).framenum = i;
        Receive(k+j).acqNum = j;
    end
end


% Specify TGC Waveform structure.
TGC.CntrlPts = [200,375,490,560,630,700,765,830];
TGC.rangeMax = P.endDepth;
TGC.Waveform = computeTGCWaveform(TGC);


% Specify Recon structure array. 
Recon = struct('senscutoff', 0.5, ...
               'pdatanum', 1, ...
               'rcvBufFrame',-1, ...
               'IntBufDest', [1,1], ...
               'ImgBufDest', [1,-1], ...  % auto-increment ImageBuffer each recon
               'RINums', 1:128);

           
% Define ReconInfo structures.
ReconInfo = repmat(struct('mode', 'replaceIntensity', ...
                   'txnum', 1, ...
                   'rcvnum', 1, ...
                   'regionnum', 0), 1, 128);
% - Set specific ReconInfo attributes.
for j = 1:128 
    ReconInfo(j).txnum = j;
    ReconInfo(j).rcvnum = j;
    ReconInfo(j).regionnum = j;
end



% Specify Process structure array.
pers = 20;
Process(1).classname = 'Image';
Process(1).method = 'imageDisplay';
Process(1).Parameters = {'imgbufnum',1,...   % number of buffer to process.
                         'framenum',-1,...   % (-1 => lastFrame)
                         'pdatanum',1,...    % number of PData structure to use
                         'pgain',1.0,...            % pgain is image processing gain
                         'reject',2,...      % reject level 
                         'persistMethod','simple',...
                         'persistLevel',pers,...
                         'interpMethod','4pt',...  %method of interp. (1=4pt)
                         'grainRemoval','none',...
                         'processMethod','none',...
                         'averageMethod','none',...
                         'compressMethod','power',...
                         'compressFactor',40,...
                         'mappingMethod','full',...
                         'display',1,...      % display image after processing
                         'displayWindow',1};
                  
%save the IQ output                    
Process(2).classname = 'External';
Process(2).method = 'saveIQ';
Process(2).Parameters = {'srcbuffer','inter',... % name of buffer to process.
    'srcbufnum',1,...
    'srcframenum',1,...
    'dstbuffer','none'};

%Save the RF              
%Process(3).classname = 'External';
%Process(3).method = 'saveRF';
%Process(3).Parameters = {'srcbuffer','receive',... % name of buffer to process.
%    'srcbufnum',1,...
%    'srcframenum',1,...
%    'dstbuffer','none'};


%Change focal point                  
%Process(4).classname = 'External';
%Process(4).method = 'changeFocus';
%Process(4).Parameters = {'srcbuffer','none',... % name of buffer to process.
%    'dstbuffer','none'};

EF(1).Function = text2cell('%EF#1');
%EF(2).Function = text2cell('%EF#2');




% Specify SeqControl structure arrays.
%  - Time between acquisitions in usec
t1 = round(2*P.endDepth*2*(1/Trans.frequency)); % acq. time in usec for max depth
SeqControl(1).command = 'timeToNextAcq';
SeqControl(1).argument = t1;
%  - Time between frames at 20 fps at max endDepth.
SeqControl(2).command = 'timeToNextAcq';
SeqControl(2).argument = pulsePeriod - t1 * 127;
%  - Return to Matlab
SeqControl(3).command = 'returnToMatlab';
%  - Jump back to start.
SeqControl(4).command = 'jump';
SeqControl(4).argument = 1;
nsc = 5; % next SeqControl number



% Specify Event structure arrays.
n = 1;
for m = 1:(acqFrames/Resource.RcvBuffer(1).numFrames)
for i = 1:Resource.RcvBuffer(1).numFrames
    for j = 1:128                      % Acquire frame
        Event(n).info = 'Aqcuisition.';
        Event(n).tx = (128*Resource.RcvBuffer(1).numFrames)*(m-1)+128*(i-1)+j;   % use next TX structure.
        Event(n).rcv = 128*(i-1)+j;   
        Event(n).recon = 0;      % no reconstruction.
        Event(n).process = 0;    % no processing
        Event(n).seqControl = 1; % seqCntrl
        n = n+1;
    end
    % Replace last events SeqControl for inter-frame timeToNextAcq.
   Event(n-1).seqControl = 2;
    
    Event(n).info = 'Transfer frame to host.';
    Event(n).tx = 0;        % no TX
    Event(n).rcv = 0;       % no Rcv
    Event(n).recon = 0;     % no Recon
    Event(n).process = 0; 
    Event(n).seqControl = nsc; 
       SeqControl(nsc).command = 'transferToHost'; % transfer frame to host buffer
       nsc = nsc+1;
    n = n+1;

    Event(n).info = 'recon and process'; 
    Event(n).tx = 0;         % no transmit
    Event(n).rcv = 0;        % no rcv
    Event(n).recon = 1;      % reconstruction
    Event(n).process = 1;    % process
    Event(n).seqControl = 0;
    if (floor(i/5) == i/5)&&(i ~= Resource.RcvBuffer(1).numFrames)  % Exit to Matlab every 5th frame
        Event(n).seqControl = 3; % return to Matlab
    end
    n = n+1;
    
    Event(n).info = 'ext func to save IQ';
    Event(n).tx = 0;         % no transmit
    Event(n).rcv = 0;        % no rcv
    Event(n).recon = 0;      % reconstruction
    Event(n).process = 2;    % process
    Event(n).seqControl = 0;    
    n = n+1; 
    
    %Event(n).info = 'ext func to save RF';
    %Event(n).tx = 0;         % no transmit
    %Event(n).rcv = 0;        % no rcv
    %Event(n).recon = 0;      % reconstruction
    %Event(n).process = 3;    % process
    %Event(n).seqControl = 0;    
    %n = n+1; 

    %{
    Event(n).info = 'ext func to chage focal point';
    Event(n).tx = 0;         % no transmit
    Event(n).rcv = 0;        % no rcv
    Event(n).recon = 0;      % reconstruction
    Event(n).process = 3;    % process
    Event(n).seqControl = 0;    
    n = n+1;
	%}
    %txCount=txCount+1;
end
end
%if k<=10
    %Event(n).info = 'Jump back';
    %Event(n).tx = 0;        % no TX
    %Event(n).rcv = 0;       % no Rcv
    %Event(n).recon = 0;     % no Recon
    %Event(n).process = 0; 
    %Event(n).seqControl = 4;
%end




















% User specified UI Control Elements
% - Sensitivity Cutoff
UI(1).Control =  {'UserB7','Style','VsSlider','Label','Sens. Cutoff',...
                  'SliderMinMaxVal',[0,1.0,Recon(1).senscutoff],...
                  'SliderStep',[0.025,0.1],'ValueFormat','%1.3f'};
UI(1).Callback = text2cell('%SensCutoffCallback');

% - Range Change
wls2mm = 1;
AxesUnit = 'wls';
if isfield(Resource.DisplayWindow(1),'AxesUnits')&&~isempty(Resource.DisplayWindow(1).AxesUnits)
    if strcmp(Resource.DisplayWindow(1).AxesUnits,'mm')
        AxesUnit = 'mm';
        wls2mm = Resource.Parameters.speedOfSound/1000/Trans.frequency;
    end
end
UI(2).Control = {'UserA1','Style','VsSlider','Label',['Range (',AxesUnit,')'],...
                 'SliderMinMaxVal',[64,300,P.endDepth]*wls2mm,'SliderStep',[0.1,0.2],'ValueFormat','%3.0f'};
UI(2).Callback = text2cell('%RangeChangeCallback');
             
% - Transmit focus change
UI(3).Control = {'UserB4','Style','VsSlider','Label',['TX Focus (',AxesUnit,')'],...
                 'SliderMinMaxVal',[20,320,P.initialFocus]*wls2mm,'SliderStep',[0.	,0.2],'ValueFormat','%3.0f'};
UI(3).Callback = text2cell('%initialFocusCallback');
             
% - F number change
UI(4).Control = {'UserB3','Style','VsSlider','Label','F Number',...
                 'SliderMinMaxVal',[1,20,round(P.initialFocus/(P.numTx*Trans.spacing))],'SliderStep',[0.05,0.1],'ValueFormat','%2.0f'};
UI(4).Callback = text2cell('%FNumCallback');

% Specify factor for converting sequenceRate to frameRate.
frameRateFactor = 4;

% Save all the structures to a .mat file.
save('L11-4v_128RyLns.mat'); 
VSX
return



% **** Callback routines to be converted by text2cell function. ****
%SensCutoffCallback - Sensitivity cutoff change
ReconL = evalin('base', 'Recon');
for i = 1:size(ReconL,2)
    ReconL(i).senscutoff = UIValue;
end
assignin('base','Recon',ReconL);
Control = evalin('base','Control');
Control.Command = 'update&Run';
Control.Parameters = {'Recon'};
assignin('base','Control', Control);
return
%SensCutoffCallback

%RangeChangeCallback - Range change
simMode = evalin('base','Resource.Parameters.simulateMode');
% No range change if in simulate mode 2.
if simMode == 2
    set(hObject,'Value',evalin('base','P.endDepth'));
    return
end
Trans = evalin('base','Trans');
Resource = evalin('base','Resource');
scaleToWvl = Trans.frequency/(Resource.Parameters.speedOfSound/1000);

P = evalin('base','P');
P.endDepth = UIValue;
if isfield(Resource.DisplayWindow(1),'AxesUnits')&&~isempty(Resource.DisplayWindow(1).AxesUnits)
    if strcmp(Resource.DisplayWindow(1).AxesUnits,'mm')
        P.endDepth = UIValue*scaleToWvl;    
    end
end
assignin('base','P',P);

PData = evalin('base','PData');
PData(1).Size(1) = ceil((P.endDepth-P.startDepth)/PData(1).PDelta(3));
PData(1).Region = repmat(struct('Shape',struct( ...
                    'Name','Rectangle',...
                    'Position',[0,0,P.startDepth],...
                    'width',Trans.spacing,...
                    'height',P.endDepth-P.startDepth)),1,128);
% - set position of regions to correspond to beam spacing.
for i = 1:128
    PData(1).Region(i).Shape.Position(1) = (-63.5 + (i-1))*Trans.spacing;
end
assignin('base','PData',PData);
evalin('base','PData(1).Region = computeRegions(PData(1));');
evalin('base','Resource.DisplayWindow(1).Position(4) = ceil(PData(1).Size(1)*PData(1).PDelta(3)/Resource.DisplayWindow(1).pdelta);');
Receive = evalin('base', 'Receive');
maxAcqLength = ceil(sqrt(P.endDepth^2 + ((Trans.numelements-1)*Trans.spacing)^2));
for i = 1:size(Receive,2)
    Receive(i).endDepth = maxAcqLength;
end
assignin('base','Receive',Receive);
evalin('base','TGC.rangeMax = P.endDepth;');
evalin('base','TGC.Waveform = computeTGCWaveform(TGC);');
evalin('base','if VDAS==1, Result = loadTgcWaveform(1); end');
Control = evalin('base','Control');
Control.Command = 'update&Run';
Control.Parameters = {'PData','InterBuffer','ImageBuffer','DisplayWindow','Receive','Recon'};
assignin('base','Control', Control);
assignin('base', 'action', 'displayChange');
return
%RangeChangeCallback

%initialFocusCallback - TX focus changel
simMode = evalin('base','Resource.Parameters.simulateMode');
% No focus change if in simulate mode 2.
if simMode == 2
    set(hObject,'Value',evalin('base','P.initialFocus'));
    return
end
Trans = evalin('base','Trans');
Resource = evalin('base','Resource');
scaleToWvl = Trans.frequency/(Resource.Parameters.speedOfSound/1000);

P = evalin('base','P');
P.initialFocus = UIValue;
if isfield(Resource.DisplayWindow(1),'AxesUnits')&&~isempty(Resource.DisplayWindow(1).AxesUnits)
    if strcmp(Resource.DisplayWindow(1).AxesUnits,'mm')
        P.initialFocus = UIValue*scaleToWvl;    
    end
end
assignin('base','P',P);

TX = evalin('base', 'TX');
for n = 1:128   % 128 transmit events
    TX(n).focus = P.initialFocus;
    TX(n).Delay = computeTXDelays(TX(n));
end
assignin('base','TX', TX);
% Update Fnumber based on new P.initialFocus
evalin('base','set(UI(4).handle(2),''Value'',round(P.initialFocus/(P.numTx*Trans.spacing)));');
evalin('base','set(UI(4).handle(3),''String'',num2str(round(P.initialFocus/(P.numTx*Trans.spacing))));');
% Set Control command to update TX
Control = evalin('base','Control');
Control.Command = 'update&Run';
Control.Parameters = {'TX'};
assignin('base','Control', Control);
return
%initialFocusCallback

%FNumCallback - F number change
simMode = evalin('base','Resource.Parameters.simulateMode');
P = evalin('base','P');
Trans = evalin('base','Trans');
% No F number change if in simulate mode 2.
if simMode == 2
    set(hObject,'Value',round(P.initialFocus/(P.numTx*Trans.spacing)));
    return
end
P.txFNum = UIValue;
P.numTx = round(P.initialFocus/(P.txFNum*Trans.spacing));
assignin('base','P',P);
% - Redefine event specific TX attributes for the new P.numTx.
TX = evalin('base', 'TX');
for n = 1:128   % 128 transmit events
    % Set transmit Apodization.
    lft = n - floor(P.numTx/2);
    if lft < 1, lft = 1; end
    rt = n + floor(P.numTx/2);
    if rt > Trans.numelements, rt = Trans.numelements; end
    TX(n).Apod = zeros(1,Trans.numelements);
    TX(n).Apod(lft:rt) = 1.0;
    TX(n).Delay = computeTXDelays(TX(n));
end
assignin('base','TX', TX);
% Set Control command to update TX
Control = evalin('base','Control');
Control.Command = 'update&Run';
Control.Parameters = {'TX'};
assignin('base','Control', Control);
return
%FNumCallback




%EF#1
saveIQ(IQBuffer)

SWIOutput = evalin('base','SWIOutput');
acqFrames = evalin('base','acqFrames');
nFr = evalin('base','nFr');
% disp(num2str(size(IQBuffer,1)))
% disp(['Placing data in SWIOutput at nFr = ' ,num2str(nFr),num2str(acqFrames)]);

%constantly save the last n frames
%if nFr <= acqFrames
%    savePos = nFr;
%else %save to the last pos
%    SWIOutput(1) = []; %clear first frame
%    savePos = acqFrames;
%end
savePos = nFr;

if nFr <=acqFrames
    SWIOutput(savePos).Data= IQBuffer;



    nFr = nFr + 1;
    assignin('base','SWIOutput',SWIOutput);
    assignin('base','nFr',nFr);
else
    disp("done");
end
return
%EF#1

%EF#2
saveRF(RFBuffer)

RFOutput = evalin('base', 'RFOutput');
acqFrames = evalin('base', 'acqFrames');
nFr = evalin('base', 'nFr');
if nFr <= acqFrames
    savePos = nFr;
    
else
    RFOutput(1) = [];
    savePos = acqFrames;
end

RFOutput(savepos).Data = RFBuffer;
assignin('base', 'RFOutput', RFOutput);

return
%EF#2

%{
%EF#2
changeFocus()

%Get total number of frames we want and current frame
acqFrames = evalin('base', 'acqFrames');
nFr = evalin('base', 'nFr');

%Get the array of focal points
ZFocal = evalin('base', 'ZFocal');

%Pull the TX structure and get the focus
TX = evalin('base', 'TX');
%currentFocus = TX(1).focus;
%sprintf('Current focus: %d), currentFocus);

%loop through the focal points
if nFr > 100
    nFr = 1;
end

newFocus = ZFocal(nFr);

%Assign the new focus
for n = 1:128
	TX(n).focus = newFocus;
	TX(n).Delay = computeTXDelays(TX(n));
end

%sprintf('New focus %d', TX(1).focus);
assignin('base', 'TX', TX);

% Set Control command to update TX
Control = evalin('base','Control');
Control.Command = 'update&Run';
Control.Parameters = {'TX'};
assignin('base','Control', Control);
return;
%EF#2
%}