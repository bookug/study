
pub enum Command {
    Set { key:String, val:String },
    Remove {key:String},
}

pub struct KvStore {
    reader : BufReaderWithPos<File>,
    writer : BufWriterWithPos<File>,
    index: HashMap<String, CommandPos>,
}

struct CommandPos {
    pos:u64,
    len:u64,
}

pub fn set(&mut self, key: String, val: String) -> Result<()> {
    let cmd = Command::Set(key, val);
    let pos = self.writer.pos;
    serde_json::to_writer(&mut self.writer, &cmd)?;
    self.writer.flush()?;
    if let Command::Set { key, .. } = cmd {
        let cmd_pos = CommandPos { pos, len:self.writer.pos - pos };
        self.index.insert(key, cmd_pos);
    }
    Ok(())
}

pub fn remove(&mut self, key:String ) -> Result<()> {
    if self.index.contains_key(&key) {
        let cmd = Command::remove(key);
        serde_json::to_writer(&mut self.writer, &cmd)?;
        self.writer.flush()?;
        if let Command::Remove {key} = cmd {
            self.index.remove(&key).expect("key not found");
        }
        Ok(())
    } else {
        Err(KvsError::KeyNotFound)
    }
}

pub fn get(&mut self, key: String) -> Result<Option<String>> {
    if let Some(cmd_pos) = self.index.get(&key) {
        let reader = &mut self.reader;
        reader.seek(SeekFrom::Start(cmd_pos.pos))?;
        let cmd_reader = reader.take(cmd_pos.len);
        if let Command::Set {value, ..} = serde_json::from_reader(cmd_reader)? {
            Ok(Some(value))
        } else {
            Err(KvsError::UnexpectedCommandType)
        } else {
            Ok(None)
        }
    }
}

fn load(reader:&mut BufferedwithPos<File>, index:&mut HashMap<String, CommandPos>) {
    let mut pos = reader.seek(SeekFrom::Start(0))?;
    let mut stream = Deserializer::from_reader(reader).into_iter::<Command>();
    while let Some(cmd) = stream.next() {
        let new_pos = stream.byte_offset() as u64;
        match cmd? {
            Command::Set {key,..} => {
                index.insert(key, CommandPos{pos, len:new_pos -pos});
            },
            Command::Remove {key} => {
                index.remove(&key);
            }
        }
        pos = new_pos;
    }
    Ok(())
}

fn main() {
    println!("Hello, world!");
}
