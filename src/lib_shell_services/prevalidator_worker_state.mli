(**************************************************************************)
(*                                                                        *)
(*    Copyright (c) 2014 - 2018.                                          *)
(*    Dynamic Ledger Solutions, Inc. <contact@tezos.com>                  *)
(*                                                                        *)
(*    All rights reserved. No warranty, explicit or implicit, provided.   *)
(*                                                                        *)
(**************************************************************************)

module Request : sig
  type 'a t =
    | Flush : Block_hash.t -> unit t
    | Notify : P2p_peer.Id.t * Mempool.t -> unit t
    | Inject : Operation.t -> unit t
    | Arrived : Operation_hash.t * Operation.t -> unit t
    | Advertise : unit t
  type view = View : _ t -> view
  val view : 'a t -> view
  val encoding : view Data_encoding.t
  val pp : Format.formatter -> view -> unit
end

module Event : sig
  type t =
    | Request of (Request.view * Worker_types.request_status * error list option)
    | Debug of string
  val level : t -> Logging.level
  val encoding : t Data_encoding.t
  val pp : Format.formatter -> t -> unit
end

module Worker_state : sig
  type view =
    { head : Block_hash.t ;
      timestamp : Time.t ;
      fetching : Operation_hash.Set.t ;
      pending : Operation_hash.Set.t ;
      applied : Operation_hash.t list ;
      delayed : Operation_hash.Set.t }
  val encoding : view Data_encoding.t
  val pp : Format.formatter -> view -> unit
end
