waitUntil{!isNil "civilianBasePos"};
waitUntil{!isNil "sizeLocation"};
createMarkerLocal ["MainTown", civilianBasePos];
while {true} do {
  "MainTown" setMarkerShape "ELLIPSE";
  "MainTown" setMarkerColor "ColorBlack";
  "MainTown" setMarkerPos civilianBasePos;
  "MainTown" setMarkerSize [sizeLocation,sizeLocation];
  sleep 5;
};
