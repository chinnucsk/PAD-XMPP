%%% Copyright (c) 2010 Tim 'Shaggy' Bielawa <timbielawa@gmail.com>
%%% 
%%% Permission is hereby granted, free of charge, to any person
%%% obtaining a copy of this software and associated documentation
%%% files (the "Software"), to deal in the Software without
%%% restriction, including without limitation the rights to use,
%%% copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the
%%% Software is furnished to do so, subject to the following
%%% conditions:
%%% 
%%% The above copyright notice and this permission notice shall be
%%% included in all copies or substantial portions of the Software.
%%% 
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
%%% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
%%% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
%%% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
%%% HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
%%% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%%% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
%%% OTHER DEALINGS IN THE SOFTWARE.

%%%-------------------------------------------------------------------
%%% File    : padxmpp.erl
%%% Description : Starts the show
%%%-------------------------------------------------------------------

-module(padxmpp).
-behaviour(supervisor).

-export([start/0, start_link/0, init/1]).
-include("shared.hrl").

start() -> spawn(fun() -> start_link() end).
start_link() ->
    supervisor:start_link({local,?MODULE}, ?MODULE, []),
    error_logger:info_msg("We made it past the supervisor loading. Thank the gods.").

init([]) ->
    {ok, {{one_for_one, 3, 10},
	  [
	   {pevent,
	    {pevent, start_link, []},
	    permanent, 
	    10000, 
	    worker, 
	    [dynamic]},
	   {padxmpp_client_sup,
	    {padxmpp_client_sup, start_link, []},
	    permanent, 
	    10000, 
	    worker, 
	    [padxmpp_client_sup]},
	   {padxmpp_conn_listener,
	    {padxmpp_conn_listener, start_link, []},
	    permanent, 
	    brutal_kill,
	    worker, 
	    [padxmpp_conn_listener]},
	   {padxmpp_conn_table, 
	    {padxmpp_conn_table, start_link, []},
	    permanent, 
	    10000, 
	    worker, 
	    [padxmpp_conn_table]},
	   {padxmpp_xml_scan,
	    {padxmpp_xml_scan, start_link, []},
	    permanent, 
	    10000, 
	    worker, 
	    [padxmpp_xml_scan]}
	  ]}}.
