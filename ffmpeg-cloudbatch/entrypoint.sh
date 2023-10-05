#!/bin/bash

function exectime {
	_START=$1
	_END=$2
	_NAME=$3
	echo "### Execution of ${_NAME} took -> $((_END-_START))"
}

_VERYSTART="$(date +%s)"
echo "### Start time: $(date)"
echo "### Transcoding ${MEDIA}"

_SRC=/input
_DST=/output

_EXTENSION="${MEDIA##*.}"
_BASENAME="$(basename "${MEDIA}")"
_FILENAME="${_BASENAME%.*}"

_MEDIAINFO_SRC_START="$(date +%s)"
mediainfo "${_SRC}"/"${MEDIA}"
_MEDIAINFO_SRC_END="$(date +%s)"

lscpu | grep -q avx512
[[ $? = 0 ]] && _ASM="avx512" || _ASM="avx2"

_FFMPEG_START="$(date +%s)"
ffmpeg \
	-i "${_SRC}"/"${MEDIA}" \
	-c:v libx264 \
	-filter:v scale="720:trunc(ow/a/2)*2" \
	-preset:v medium \
	-x264-params "keyint=120:min-keyint=120:sliced-threads=0:scenecut=0:asm=${_ASM}" \
	-tune psnr -profile:v high -b:v 6M -maxrate 12M -bufsize 24M -r 60 \
	-c:a copy \
	-y \
	"${_DST}"/"${_FILENAME}-hd.mp4"
_FFMPEG_END="$(date +%s)"

_MEDIAINFO_DST_START="$(date +%s)"
mediainfo "${_DST}"/"${_FILENAME}-hd.mp4"
_MEDIAINFO_DST_END="$(date +%s)"

exectime ${_MEDIAINFO_SRC_START} ${_MEDIAINFO_SRC_END} "original Mediainfo"
exectime ${_FFMPEG_START} ${_FFMPEG_END} "FFMpeg transcoding"
exectime ${_MEDIAINFO_DST_START} ${_MEDIAINFO_DST_END} "transcoded Mediainfo"
_VERYEND="$(date +%s)"

exectime ${_VERYSTART} ${_VERYEND} "the entire process"
echo "### Ending at: $(date)"
