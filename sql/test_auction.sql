
create table items(
  itemID INTEGER PRIMARY KEY,
  status TEXT,
  descr TEXT,
  starting_price INTEGER,
  skdb_author INTEGER
);

create table bids (
  itemID INTEGER NOT NULL,
  price INTEGER NOT NULL,
  skdb_author INTEGER
);

create reactive view bids_items as
  select bids.itemID as itemID,
         price as price,
         datetime('now') as time,
         local_sequence_number() as tick,
         status
  from bids, items
  where bids.itemID = items.itemID
;

create reactive view best_bids as
  select bids_items.itemID,
         max(price) as price
    from bids_items
group by itemID;

create reactive view bids_by_user as
  select itemID, price, skdb_author as skdb_access from bids;


