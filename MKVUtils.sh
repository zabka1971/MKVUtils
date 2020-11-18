
#!/bin/bash
BASE_DIR="/home/zabka1971/Downloads/Fringe/Season 05/"
MKVMERGE_OPTION_FILE="$BASE_DIR"/"mkvmerge_option_file.json"
for VIDEO_PATH_NAME_EXT in "$BASE_DIR"/*.avi; do

	VIDEO_PATH=${VIDEO_PATH_NAME_EXT%/*}
	VIDEO_NAME_EXT=${VIDEO_PATH_NAME_EXT##*/}
	VIDEO_NAME=${VIDEO_NAME_EXT%%.*}
	#VIDEO_EXT=${VIDEO_NAME_EXT#*.}
	VIDEO_PATH_NAME=$VIDEO_PATH/$VIDEO_NAME

	#printf '%s\n' "[" "  \"--ui-language\"," "  \"en_US\","
  cat >"$MKVMERGE_OPTION_FILE" <<EOF
[
  "--ui-language",
  "en_US",
  "--output",
  "$VIDEO_PATH_NAME.mkv",
  "--language",
  "0:und",
  "--track-name",
  "0:video track",
  "--language",
  "1:cze",
  "--track-name",
  "1:audio track",
  "(",
  "$VIDEO_PATH_NAME_EXT",
  ")",
EOF

	#subtitle file exists
	if [ -r "$VIDEO_PATH_NAME.srt" ]; then
		TRACK_ORDER="0:0,0:1,1:0"
		cat >>"$MKVMERGE_OPTION_FILE" <<EOF
  "--language",
  "0:eng",
  "--track-name",
  "0:subtitle track",
  "(",
  "$VIDEO_PATH_NAME.srt",
  ")",
EOF
	else
		TRACK_ORDER="0:0,0:1"
	fi
	

	#poster file exists
	if [ -r "$VIDEO_PATH_NAME.jpg" ]; then
		cat >>"$MKVMERGE_OPTION_FILE" <<EOF
  "--attachment-description",
  "poster",
  "--attachment-name",
  "$VIDEO_NAME.jpg",
  "--attachment-mime-type",
  "image/jpeg",
  "--attach-file",
  "$VIDEO_PATH_NAME.jpg",
EOF
	fi
	
	cat >>"$MKVMERGE_OPTION_FILE" <<EOF
  "--title",
  "$VIDEO_NAME",
  "--track-order",
  "$TRACK_ORDER"
]
EOF

	mkvmerge @"$MKVMERGE_OPTION_FILE"

done

if [ -r "$MKVMERGE_OPTION_FILE" ]; then
  rm "$MKVMERGE_OPTION_FILE"
fi