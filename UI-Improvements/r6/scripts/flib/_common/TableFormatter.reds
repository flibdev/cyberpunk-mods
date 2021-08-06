
//module flib._common.TableFormatter
//use flib._common.StringUtils

enum ColumnAlignment {
  Left = 0,
  Center = 1,
  Right = 2
}

public class TableFormatterColumn {
  public let header: String;
  public let width: Int32;
  public let align: ColumnAlignment;
}

public class TableFormatter {
  protected let m_columns: array<ref<TableFormatterColumn>>;
  protected let m_padding: Int32;
  protected let m_padStr: String;
  protected let m_colSep: String;
  protected let m_headSep: String;

  public static func Make() -> ref<TableFormatter> {
    let tf: ref<TableFormatter> = new TableFormatter();
    ArrayClear(tf.m_columns);
    tf.SetFormatting(1, "|", "=");
    return tf;
  }

  public func SetFormatting(padding: Int32, columnSeparator: String, headerSeparator: String) -> Void {
    this.m_padding = Max(padding, 0);
    this.m_padStr  = StringUtils.StrRepeat(" ", this.m_padding);
    this.m_colSep  = StrLen(columnSeparator) > 0 ? columnSeparator : "|";
    this.m_headSep = StrLen(headerSeparator) > 0 ? headerSeparator : "=";
  }

  public func AddColumn(header: String, maxWidth: Int32, align: ColumnAlignment) -> Void {
    let col: ref<TableFormatterColumn> = new TableFormatterColumn();
    col.header = header;
    col.width = Max(maxWidth, StrLen(col.header));
    col.align = align;
    ArrayPush(this.m_columns, col);
  }

  public func PrintHeader() -> String {
    let headers: array<String>;
    let headRow: String = "";
    let sepRow: String = "";

    let i = 0;
    while i < ArraySize(this.m_columns) {
      let col: ref<TableFormatterColumn> = this.m_columns[i];

      ArrayPush(headers, col.header);

      if i > 0 {
        sepRow += this.m_colSep;
      }
      sepRow += StringUtils.StrRepeat(this.m_headSep, col.width + this.m_padding*2);

      i += 1;
    }
    
    headRow = this.PrintRow(headers);

    return headRow + "\n" + sepRow;
  }

  public func PrintRow(row: array<String>) -> String {
    let cols = Min(ArraySize(this.m_columns), ArraySize(row));
    let i = 0;
    let o: String = "";

    while i < cols {
      let col: ref<TableFormatterColumn> = this.m_columns[i];

      o += this.m_padStr;
      if i > 0 {
        o += this.m_colSep + this.m_padStr;
      }

      switch col.align {
        case ColumnAlignment.Left:
          o += StringUtils.RightPad(row[i], col.width);
          break;
        case ColumnAlignment.Center:
          o += StringUtils.CenterPad(row[i], col.width);
          break;
        case ColumnAlignment.Right:
          o += StringUtils.LeftPad(row[i], col.width);
          break;
      }

      i += 1;
    }

    return o;
  }

  public func LogHeader() -> Void {
    Log(this.PrintHeader());
  }

  public func LogRow(row: array<String>) -> Void {
    Log(this.PrintRow(row));
  }
}
