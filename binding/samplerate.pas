//
// samplerate.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(*
** Copyright (c) 2002-2016, Erik de Castro Lopo <erikd@mega-nerd.com>
** All rights reserved.
**
** This code is released under 2-clause BSD license. Please see the
** file at : https://github.com/erikd/libsamplerate/blob/master/COPYING
*)

(*
** API documentation is available here:
**     http://www.mega-nerd.com/SRC/api.html
*)

unit samplerate;

{$mode objfpc}{$H+}

interface

uses
  ctypes;

const
  LIB_SAMPLERATE = 'libsamplerate-0.dll';
  SAMPLERATE_VERSION = '0.1.9';

type
  ppcfloat = ^pcfloat;

// #ifndef SAMPLERATE_H
// #define SAMPLERATE_H

// #ifdef __cplusplus
// extern "C" {
// #endif    (* __cplusplus *)


type
(* Opaque data type SRC_STATE. *)
  PSRC_STATE = ^SRC_STATE;
  SRC_STATE = record
  end;

(* SRC_DATA is used to pass data to src_simple() and src_process(). *)
  PSRC_DATA = ^SRC_DATA;
  SRC_DATA = record
    data_in: pcfloat;
    data_out: pcfloat;

    input_frames: clong;
    output_frames: clong;
    input_frames_used: clong;
    output_frames_gen: clong;

    end_of_input: cint;

    src_ratio: cdouble;
  end;

(*
** User supplied callback function type for use with src_callback_new()
** and src_callback_read(). First parameter is the same pointer that was
** passed into src_callback_new(). Second parameter is pointer to a
** pointer. The user supplied callback function must modify *data to
** point to the start of the user supplied float array. The user supplied
** function must return the number of frames that **data points to.
*)
  src_callback_t = function (cb_data: pointer; data: ppcfloat): clong; cdecl;

(*
**    Standard initialisation function : return an anonymous pointer to the
**    internal state of the converter. Choose a converter from the enums below.
**    Error returned in *error.
*)
function src_new(converter_type: cint; channels: cint; error: pcint): PSRC_STATE; cdecl external LIB_SAMPLERATE;

(*
**    Initilisation for callback based API : return an anonymous pointer to the
**    internal state of the converter. Choose a converter from the enums below.
**    The cb_data pointer can point to any data or be set to NULL. Whatever the
**    value, when processing, user supplied function "func" gets called with
**    cb_data as first parameter.
*)
function src_callback_new(func: src_callback_t; converter_type: cint; channels: cint; error: pcint; cb_data: pointer): PSRC_STATE; cdecl external LIB_SAMPLERATE;

(*
**    Cleanup all internal allocations.
**    Always returns NULL.
*)
function src_delete(state: PSRC_STATE): PSRC_STATE; cdecl external LIB_SAMPLERATE;

(*
**    Standard processing function.
**    Returns non zero on error.
*)
function src_process(state: PSRC_STATE; data: PSRC_DATA): cint; cdecl external LIB_SAMPLERATE;

(*
**    Callback based processing function. Read up to frames worth of data from
**    the converter int *data and return frames read or -1 on error.
*)
function src_callback_read(state: PSRC_STATE; src_ratio: cdouble; frames: clong; data: pcfloat): clong; cdecl external LIB_SAMPLERATE;

(*
**    Simple interface for performing a single conversion from input buffer to
**    output buffer at a fixed conversion ratio.
**    Simple interface does not require initialisation as it can only operate on
**    a single buffer worth of audio.
*)
function src_simple(data: PSRC_DATA; converter_type: cint; channels: cint): cint; cdecl external LIB_SAMPLERATE;

(*
** This library contains a number of different sample rate converters,
** numbered 0 through N.
**
** Return a string giving either a name or a more full description of each
** sample rate converter or NULL if no sample rate converter exists for
** the given value. The converters are sequentially numbered from 0 to N.
*)
function src_get_name(converter_type: cint): pchar; cdecl external LIB_SAMPLERATE;
function src_get_description(converter_type: cint): pchar; cdecl external LIB_SAMPLERATE;
function src_get_version(): pchar; cdecl external LIB_SAMPLERATE;

(*
**    Set a new SRC ratio. This allows step responses
**    in the conversion ratio.
**    Returns non zero on error.
*)
function src_set_ratio(state: PSRC_STATE; new_ratio: cdouble): cint; cdecl external LIB_SAMPLERATE;

(*
**    Get the current channel count.
**    Returns negative on error, positive channel count otherwise
*)
function src_get_channels(state: PSRC_STATE): cint; cdecl external LIB_SAMPLERATE;

(*
**    Reset the internal SRC state.
**    Does not modify the quality settings.
**    Does not free any memory allocations.
**    Returns non zero on error.
*)
function src_reset(state: PSRC_STATE): cint; cdecl external LIB_SAMPLERATE;

(*
** Return TRUE if ratio is a valid conversion ratio, FALSE
** otherwise.
*)
function src_is_valid_ratio(ratio: cdouble): cint; cdecl external LIB_SAMPLERATE;

(*
**    Return an error number.
*)
function src_error(state: PSRC_STATE): cint; cdecl external LIB_SAMPLERATE;

(*
**    Convert the error number into a string.
*)
function src_strerror(error: cint): pchar; cdecl external LIB_SAMPLERATE;

(*
** The following enums can be used to set the interpolator type
** using the function src_set_converter().
*)
type
  SRC_ENUM = (
    SRC_SINC_BEST_QUALITY = 0,
    SRC_SINC_MEDIUM_QUALITY = 1,
    SRC_SINC_FASTEST = 2,
    SRC_ZERO_ORDER_HOLD = 3,
    SRC_LINEAR = 4
  );

(*
** Extra helper functions for converting from short to float and
** back again.
*)
procedure src_short_to_float_array(const in_: pcshort; out_: pcfloat; len: cint); cdecl external LIB_SAMPLERATE;
procedure src_float_to_short_array(const in_: pcfloat; out_: pcshort; len: cint); cdecl external LIB_SAMPLERATE;

procedure src_int_to_float_array(const in_: pcint; out_: pcfloat; len: cint); cdecl external LIB_SAMPLERATE;
procedure src_float_to_int_array(const in_: pcfloat; out_: pcint; len: cint); cdecl external LIB_SAMPLERATE;

// #ifdef __cplusplus
// }        (* extern "C" *)
// #endif    (* __cplusplus *)

// #endif    (* SAMPLERATE_H *)

implementation


end.
