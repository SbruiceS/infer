(*
 * Copyright (c) 2018-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd

module AbstractAddress : sig
  type t = private int [@@deriving compare]

  val nullptr : t

  val mk_fresh : unit -> t
end

type t

include AbstractDomain.S with type astate = t

val initial : t

module Diagnostic : sig
  type t

  val get_message : t -> string

  val get_location : t -> Location.t

  val get_issue_type : t -> IssueType.t

  val get_trace : t -> Errlog.loc_trace
end

type 'a access_result = ('a, Diagnostic.t) result

val read : Location.t -> AccessExpression.t -> t -> (t * AbstractAddress.t) access_result

val read_all : Location.t -> AccessExpression.t list -> t -> t access_result

val havoc_var : Var.t -> t -> t

val havoc : Location.t -> AccessExpression.t -> t -> t access_result

val write : Location.t -> AccessExpression.t -> AbstractAddress.t -> t -> t access_result

val invalidate : PulseInvalidation.t -> Location.t -> AccessExpression.t -> t -> t access_result
