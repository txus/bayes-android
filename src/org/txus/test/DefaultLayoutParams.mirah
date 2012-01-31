import android.widget.RelativeLayout
import android.widget.RelativeLayout.LayoutParams

class DefaultLayoutParams
  def self.params
    RelativeLayout.LayoutParams.new(
      -2, -2 # Wrap content
    )
  end
end
